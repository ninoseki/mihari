# frozen_string_literal: true

module Mihari
  class Rule < Service
    include Concerns::FalsePositiveValidatable

    # @return [Hash]
    attr_reader :data

    # @return [Array, nil]
    attr_reader :errors

    # @return [Time]
    attr_reader :base_time

    #
    # Initialize
    #
    # @param [Hash] data
    #
    def initialize(**data)
      super()

      @data = data.deep_symbolize_keys
      @errors = nil
      @base_time = Time.now.utc

      validate!
    end

    #
    # @return [Boolean]
    #
    def errors?
      return false if @errors.nil?

      !@errors.empty?
    end

    def [](key)
      data key.to_sym
    end

    #
    # @return [String]
    #
    def id
      data[:id]
    end

    #
    # @return [String]
    #
    def title
      data[:title]
    end

    #
    # @return [String]
    #
    def description
      data[:description]
    end

    #
    # @return [String]
    #
    def yaml
      data.deep_stringify_keys.to_yaml
    end

    #
    # @return [Array<Hash>]
    #
    def queries
      data[:queries]
    end

    #
    # @return [Array<String>]
    #
    def data_types
      data[:data_types]
    end

    #
    # @return [Date, nil]
    #
    def created_on
      data[:created_on]
    end

    #
    # @return [Date, nil]
    #
    def updated_on
      data[:updated_on]
    end

    #
    # @return [Array<Mihari::Models::Tag>]
    #
    def tags
      data[:tags].uniq.filter_map do |name|
        Models::Tag.find_or_create_by(name: name)
      end
    end

    #
    # @return [Array<Mihari::Models::Tagging>]
    #
    def taggings
      tags.map { |tag| Models::Tagging.find_or_create_by(tag_id: tag.id, rule_id: id) }
    end

    #
    # @return [Array<String, RegExp>]
    #
    def falsepositives
      @falsepositives ||= data[:falsepositives].map { |fp| normalize_falsepositive fp }
    end

    #
    # @return [Integer, nil]
    #
    def artifact_ttl
      data[:artifact_ttl]
    end

    #
    # Returns a list of artifacts matched with queries/analyzers (with the rule ID)
    #
    # @return [Array<Mihari::Models::Artifact>]
    #
    def artifacts
      analyzer_results.flat_map do |result|
        artifacts = result.value!
        artifacts.map do |artifact|
          artifact.rule_id = id
          artifact
        end
      end
    end

    #
    # Normalize artifacts
    # - Reject invalid artifacts (for just in case)
    # - Select artifacts with allowed data types
    # - Reject artifacts with false positive values
    # - Set rule ID
    #
    # @return [Array<Mihari::Models::Artifact>]
    #
    def normalized_artifacts
      valid_artifacts = artifacts.uniq(&:data).select(&:valid?)
      date_type_allowed_artifacts = valid_artifacts.select { |artifact| data_types.include? artifact.data_type }
      date_type_allowed_artifacts.reject { |artifact| falsepositive? artifact.data }
    end

    #
    # Uniquify artifacts (assure rule level uniqueness)
    #
    # @return [Array<Mihari::Models::Artifact>]
    #
    def unique_artifacts
      normalized_artifacts.select do |artifact|
        artifact.unique?(base_time: base_time, artifact_ttl: artifact_ttl)
      end
    end

    #
    # Enriched artifacts
    #
    # @return [Array<Mihari::Models::Artifact>]
    #
    def enriched_artifacts
      @enriched_artifacts ||= Parallel.map(unique_artifacts) do |artifact|
        enrichers.each { |enricher| artifact.enrich_by_enricher enricher }
        artifact
      end
    end

    #
    # Bulk emit
    #
    # @return [Array<Mihari::Models::Alert>]
    #
    def bulk_emit
      return [] if enriched_artifacts.empty?

      # NOTE: separate parallel execution and logging
      #       because the logger does not work along with Parallel
      results = Parallel.map(emitters) { |emitter| emitter.result enriched_artifacts }
      results.zip(emitters).map do |result_and_emitter|
        result, emitter = result_and_emitter

        case result
        when Success
          Mihari.logger.info "Emission by #{emitter.class} succeed"
        else
          Mihari.logger.info "Emission by #{emitter.class} failed: #{result.failure}"
        end

        result.value_or nil
      end.compact
    end

    #
    # Set artifacts & run emitters in parallel
    #
    # @return [Mihari::Models::Alert, nil]
    #
    def call
      # Validate analyzers & emitters before using them
      analyzers
      emitters

      alert_or_something = bulk_emit
      # Return Mihari::Models::Alert created by the database emitter
      alert_or_something.find { |res| res.is_a?(Mihari::Models::Alert) }
    end

    #
    # @return [Mihari::Models::Rule]
    #
    def model
      Mihari::Models::Rule.find(id).tap do |rule|
        rule.title = title
        rule.description = description
        rule.data = data
        rule.taggings = taggings
      end
    rescue ActiveRecord::RecordNotFound
      Mihari::Models::Rule.new(
        id: id,
        title: title,
        description: description,
        data: data,
        taggings: taggings
      )
    end

    #
    # @return [Boolean]
    #
    def diff?
      model = Mihari::Models::Rule.find(id)
      model.data != diff_comparable_data
    rescue ActiveRecord::RecordNotFound
      false
    end

    #
    # @return [Boolean]
    #
    def exists?
      Mihari::Models::Rule.exists? id
    end

    def update_or_create
      model.save
    end

    class << self
      #
      # Load rule from YAML string
      #
      # @param [String] yaml
      #
      # @return [Mihari::Rule]
      #
      def from_yaml(yaml)
        data = YAML.safe_load(ERB.new(yaml).result, permitted_classes: [Date, Symbol])
        new(**data)
      end

      #
      # @param [Mihari::Models::Rule] model
      #
      # @return [Mihari::Rule]
      #
      def from_model(model)
        new(**model.data)
      end
    end

    private

    #
    # @return [Hash]
    #
    def diff_comparable_data
      # data is serialized as JSON so dates (created_on & updated_on) are stringified in there
      # thus dates & (hash) keys have to be stringified when comparing
      data.deep_dup.tap do |data|
        data[:created_on] = created_on.to_s unless created_on.nil?
        data[:updated_on] = updated_on.to_s unless updated_on.nil?
      end.deep_stringify_keys
    end

    #
    # Check whether a value is a falsepositive value or not
    #
    # @return [Boolean]
    #
    def falsepositive?(value)
      return true if falsepositives.include?(value)

      regexps = falsepositives.select { |fp| fp.is_a?(Regexp) }
      regexps.any? { |fp| fp.match?(value) }
    end

    #
    # Get analyzer class
    #
    # @param [String] key
    #
    # @return [Class<Mihari::Analyzers::Base>] analyzer class
    #
    def get_analyzer_class(key)
      raise ArgumentError, "#{key} is not supported" unless Mihari.analyzer_to_class.key?(key)

      Mihari.analyzer_to_class[key]
    end

    #
    # @return [Array<Mihari::Analyzers::Base>]
    #
    def analyzers
      @analyzers ||= queries.map do |params|
        analyzer_name = params[:analyzer]
        klass = get_analyzer_class(analyzer_name)
        analyzer = klass.from_query(params)
        analyzer.validate_configuration!
        analyzer
      end
    end

    def parallel_analyzers
      analyzers.select(&:parallel?)
    end

    def serial_analyzers
      analyzers.reject(&:parallel?)
    end

    # @return [Array<Dry::Monads::Result::Success<Array<Mihari::Models::Artifact>>, Dry::Monads::Result::Failure>]
    def analyzer_results
      parallel_results = Parallel.map(parallel_analyzers, &:result)
      serial_results = serial_analyzers.map(&:result)
      parallel_results + serial_results
    end

    #
    # Get emitter class
    #
    # @param [String] key
    #
    # @return [Class<Mihari::Emitters::Base>] emitter class
    #
    def get_emitter_class(key)
      raise ArgumentError, "#{key} is not supported" unless Mihari.emitter_to_class.key?(key)

      Mihari.emitter_to_class[key]
    end

    #
    # @return [Array<Mihari::Emitters::Base>]
    #
    def emitters
      @emitters ||= data[:emitters].map(&:deep_dup).map do |params|
        name = params[:emitter]
        options = params[:options]

        %i[emitter options].each { |key| params.delete key }

        klass = get_emitter_class(name)
        emitter = klass.new(rule: self, options: options, **params)
        emitter.validate_configuration!
        emitter
      end
    end

    #
    # Get enricher class
    #
    # @param [String] key
    #
    # @return [Class<Mihari::Enrichers::Base>] enricher class
    #
    def get_enricher_class(key)
      raise ArgumentError, "#{key} is not supported" unless Mihari.enricher_to_class.key?(key)

      Mihari.enricher_to_class[key]
    end

    #
    # @return [Array<Mihari::Enrichers::Base>] enrichers
    #
    def enrichers
      @enrichers ||= data[:enrichers].map(&:deep_dup).map do |params|
        name = params[:enricher]
        options = params[:options]

        %i[enricher options].each { |key| params.delete key }

        klass = get_enricher_class(name)
        klass.new(options: options, **params)
      end
    end

    #
    # Validate the data format
    #
    def validate!
      contract = Schemas::RuleContract.new
      result = contract.call(data)

      @data = result.to_h
      @errors = result.errors

      raise ValidationError.new("Validation failed", errors) if errors?
    end
  end
end
