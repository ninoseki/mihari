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

      # @return [String]
      attr_reader :yaml

      # @return [Array, nil]
      attr_reader :errors

      # @return [String]
      attr_writer :id

      #
      # Initialize
      #
      # @param [Hash] data
      # @param [String] yaml
      #
      def initialize(data, yaml)
        @data = data.deep_symbolize_keys
        @yaml = yaml

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
        @id ||= data[:id] || UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, data.to_yaml).to_s
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
      # @return [Mihari::Rule]
      #
      def to_model
        rule = Mihari::Rule.find(id)

        rule.title = title
        rule.description = description
        rule.data = data
        rule.yaml = yaml

        rule
      rescue ActiveRecord::RecordNotFound
        Mihari::Rule.new(
          id: id,
          title: title,
          description: description,
          data: data,
          yaml: yaml
        )
      end

      #
      # @return [Mihari::Analyzers::Rule]
      #
      def to_analyzer
        analyzer = Mihari::Analyzers::Rule.new(
          title: self[:title],
          description: self[:description],
          tags: self[:tags],
          queries: self[:queries],
          allowed_data_types: self[:allowed_data_types],
          disallowed_data_values: self[:disallowed_data_values],
          emitters: self[:emitters],
          enrichers: self[:enrichers],
          id: id
        )
        analyzer.ignore_old_artifacts = self[:ignore_old_artifacts]
        analyzer.ignore_threshold = self[:ignore_threshold]

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

          Structs::Rule.new(data, model.yaml)
        end

        #
        # @param [String] yaml
        #
        # @return [Mihari::Structs::Rule]
        # @param [String, nil] id
        #
        def from_yaml(yaml, id: nil)
          data = load_erb_yaml(yaml)
          # set ID if id is given & YAML data do not have ID
          data[:id] = id if !id.nil? && !data.key?(:id)

          Structs::Rule.new(data, yaml)
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
            rule = Mihari::Rule.find(id)
            rule.yaml || rule.symbolized_data.to_yaml
          rescue ActiveRecord::RecordNotFound
            raise ArgumentError, "ID:#{id} is not found in the database"
          end
        end
      end
    end
  end
end
