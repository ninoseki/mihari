# frozen_string_literal: true

module Mihari
  class Rule
    include Mixins::FalsePositive

    # @return [Mihari::Services::RuleProxy]
    attr_reader :rule

    # @return [Time]
    attr_reader :base_time

    #
    # @param [Mihari::Services::RuleProxy] rule
    #
    def initialize(rule)
      @rule = rule
      @base_time = Time.now.utc

      validate_analyzer_configurations
    end

    #
    # Returns a list of artifacts matched with queries/analyzers (with the rule ID)
    #
    # @return [Array<Mihari::Models::Artifact>]
    #
    def artifacts
      analyzers.flat_map do |analyzer|
        result = analyzer.result

        raise result.failure if result.failure? && !analyzer.ignore_error?

        artifacts = result.value!
        artifacts.map do |artifact|
          artifact.rule_id = rule.id
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
      date_type_allowed_artifacts = valid_artifacts.select { |artifact| rule.data_types.include? artifact.data_type }
      date_type_allowed_artifacts.reject { |artifact| falsepositive? artifact.data }
    end

    #
    # Uniquify artifacts (assure rule level uniqueness)
    #
    # @return [Array<Mihari::Models::Artifact>]
    #
    def unique_artifacts
      normalized_artifacts.select do |artifact|
        artifact.unique?(base_time: base_time, artifact_lifetime: rule.artifact_lifetime)
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
      results = Parallel.map(valid_emitters) do |emitter|
        emitter.result
      end

      results.zip(valid_emitters).map do |result_and_emitter|
        result, emitter = result_and_emitter

        Mihari.logger.info "Emission by #{emitter.class} is failed: #{result.failure}" if result.failure?
        Mihari.logger.info "Emission by #{emitter.class} is succeeded" if result.success?

        result.value_or nil
      end.compact
    end

    #
    # Set artifacts & run emitters in parallel
    #
    # @return [Mihari::Models::Alert, nil]
    #
    def run
      alert_or_something = bulk_emit
      # returns Mihari::Models::Alert created by the database emitter
      alert_or_something.find { |res| res.is_a?(Mihari::Models::Alert) }
    end

    private

    #
    # Check whether a value is a falsepositive value or not
    #
    # @return [Boolean]
    #
    def falsepositive?(value)
      return true if rule.falsepositives.include?(value)

      regexps = rule.falsepositives.select { |fp| fp.is_a?(Regexp) }
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
      rule.queries.map do |query_params|
        analyzer_name = query_params[:analyzer]
        klass = get_analyzer_class(analyzer_name)
        klass.from_query(query_params)
      end
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
      rule.emitters.map(&:deep_dup).map do |params|
        name = params[:emitter]
        options = params[:options]

        %i[emitter options].each { |key| params.delete key }

        klass = get_emitter_class(name)
        klass.new(artifacts: enriched_artifacts, rule: rule, options: options, **params)
      end
    end

    #
    # @return [Array<Mihari::Emitters::Base>]
    #
    def valid_emitters
      @valid_emitters ||= emitters.select(&:valid?)
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
      @enrichers ||= rule.enrichers.map(&:deep_dup).map do |params|
        name = params[:enricher]
        options = params[:options]

        %i[enricher options].each { |key| params.delete key }

        klass = get_enricher_class(name)
        klass.new(options: options, **params)
      end
    end

    #
    # Validate configuration of analyzers
    #
    def validate_analyzer_configurations
      analyzers.map do |analyzer|
        next if analyzer.configured?

        joined = analyzer.configuration_keys.join(", ")
        be = (analyzer.configuration_keys.length > 1) ? "are" : "is"
        message = "#{analyzer.class.class_key} is not configured correctly. #{joined} #{be} missing."
        raise ConfigurationError, message
      end
    end
  end
end
