# frozen_string_literal: true

require "date"
require "erb"
require "json"
require "pathname"
require "yaml"

module Mihari
  module Structs
    class Rule
      # @return [Hash]
      attr_reader :data

      # @return [Array, nil]
      attr_reader :errors

      #
      # Initialize
      #
      # @param [Hash] data
      #
      def initialize(data)
        @data = data.deep_symbolize_keys

        @errors = nil

        validate
      end

      #
      # @return [Boolean]
      #
      def errors?
        return false if @errors.nil?

        !@errors.empty?
      end

      def validate
        contract = Schemas::RuleContract.new
        result = contract.call(data)

        @data = result.to_h
        @errors = result.errors
      end

      def validate!
        raise RuleValidationError if errors?
      rescue RuleValidationError => e
        Mihari.logger.error "Failed to parse the input as a rule:"
        Mihari.logger.error JSON.pretty_generate(errors.to_h)

        raise e
      end

      def [](key)
        data[key.to_sym]
      end

      #
      # @return [String]
      #
      def id
        @id ||= data[:id]
      end

      #
      # @return [String]
      #
      def title
        @title ||= data[:title]
      end

      #
      # @return [String]
      #
      def description
        @description ||= data[:description]
      end

      #
      # @return [String]
      #
      def yaml
        @yaml ||= data.deep_stringify_keys.to_yaml
      end

      #
      # @return [Array<Hash>]
      #
      def queries
        @queries ||= data[:queries]
      end

      #
      # @return [Array<String>]
      #
      def data_types
        @data_types ||= data[:data_types]
      end

      #
      # @return [Array<String>, nil]
      #
      def tags
        @tags ||= data[:tags]
      end

      #
      # @return [Array<String>]
      #
      def falsepositives
        @falsepositives ||= data[:falsepositives]
      end

      #
      # @return [Array<Hash>]
      #
      def emitters
        @emitters ||= data[:emitters]
      end

      #
      # @return [Array<Hash>]
      #
      def enrichers
        @enrichers ||= data[:enrichers]
      end

      #
      # @return [Mihari::Rule]
      #
      def to_model
        rule = Mihari::Rule.find(id)

        rule.title = title
        rule.description = description
        rule.data = data

        rule
      rescue ActiveRecord::RecordNotFound
        Mihari::Rule.new(
          id: id,
          title: title,
          description: description,
          data: data
        )
      end

      #
      # @return [Mihari::Analyzers::Rule]
      #
      def to_analyzer
        analyzer = Mihari::Analyzers::Rule.new(
          title: title,
          description: description,
          tags: tags,
          queries: queries,
          data_types: data_types,
          falsepositives: falsepositives,
          emitters: emitters,
          enrichers: enrichers,
          id: id,
          rule: self
        )
        analyzer.artifact_lifetime = self[:artifact_lifetime]

        analyzer
      end

      class << self
        include Mixins::Database

        #
        # @param [Mihari::Rule] model
        #
        # @return [Mihari::Structs::Rule]
        #
        def from_model(model)
          data = model.data.deep_symbolize_keys
          # set ID if YAML data do not have ID
          data[:id] = model.id unless data.key?(:id)

          Structs::Rule.new(data)
        end

        #
        # @param [String] yaml
        #
        # @return [Mihari::Structs::Rule]
        # @param [String, nil] id
        #
        def from_yaml(yaml, id: nil)
          data = load_erb_yaml(yaml)

          Structs::Rule.new(data)
        end

        #
        # @param [String] path_or_id Path to YAML file or YAML string or ID of a rule in the database
        #
        # @return [Mihari::Structs::Rule]
        #
        def from_path_or_id(path_or_id)
          yaml = nil

          yaml = load_yaml_from_file(path_or_id) if File.exist?(path_or_id)
          yaml = load_yaml_from_db(path_or_id) if yaml.nil?

          Structs::Rule.from_yaml yaml
        end

        private

        #
        # Load ERR templated YAML
        #
        # @param [String] yaml
        #
        # @return [Hash]
        #
        def load_erb_yaml(yaml)
          YAML.safe_load(ERB.new(yaml).result, permitted_classes: [Date, Symbol], symbolize_names: true)
        rescue Psych::SyntaxError => e
          raise YAMLSyntaxError, e.message
        end

        #
        # Load YAML string from path
        #
        # @param [String] path
        #
        # @return [String, nil]
        #
        def load_yaml_from_file(path)
          return nil unless Pathname(path).exist?

          File.read path
        end

        #
        # Load YAML string from the database
        #
        # @param [String] id <description>
        #
        # @return [Hash]
        #
        def load_yaml_from_db(id)
          with_db_connection do
            Mihari::Rule.find(id)
          rescue ActiveRecord::RecordNotFound
            raise ArgumentError, "ID:#{id} is not found in the database"
          end
        end
      end
    end
  end
end
