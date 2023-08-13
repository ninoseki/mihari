# frozen_string_literal: true

require "date"
require "erb"
require "json"
require "pathname"
require "securerandom"
require "yaml"

module Mihari
  module Services
    #
    # proxy (or converter) class for rule
    # proxying rule schema data into analyzer & model
    #
    class RuleProxy
      include Mixins::FalsePositive

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
        return unless errors?

        Mihari.logger.error "Failed to parse the input as a rule:"
        Mihari.logger.error JSON.pretty_generate(errors.to_h)

        raise RuleValidationError, errors
      end

      def [](key)
        data key.to_sym
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
      # @return [Array<String>]
      #
      def tags
        @tags ||= data[:tags]
      end

      #
      # @return [Array<String, RegExp>]
      #
      def falsepositives
        @falsepositives ||= data[:falsepositives].map { |fp| normalize_falsepositive fp }
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
      # @return [Integer, nil]
      #
      def artifact_lifetime
        @artifact_lifetime ||= data[:artifact_lifetime] || data[:artifact_ttl]
      end

      #
      # @return [Mihari::Rule]
      #
      def model
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
      def analyzer
        Mihari::Analyzers::Rule.new self
      end

      class << self
        #
        # Load rule from YAML string
        #
        # @param [String] yaml
        #
        # @return [Mihari::Services::Rule]
        #
        def from_yaml(yaml)
          Services::RuleProxy.new YAML.safe_load(ERB.new(yaml).result, permitted_classes: [Date, Symbol])
        rescue Psych::SyntaxError => e
          raise YAMLSyntaxError, e.message
        end

        #
        # @param [Mihari::Rule] model
        #
        # @return [Mihari::Services::Rule]
        #
        def from_model(model)
          Services::RuleProxy.new model.data
        end

        #
        # Load a rule from path
        #
        # @param [String] path
        #
        # @return [Mihari::Services::Rule, nil]
        #
        def from_path(path)
          return nil unless Pathname(path).exist?

          from_yaml File.read(path)
        end

        #
        # Load a rule from DB
        #
        # @param [String] id
        #
        # @return [Mihari::Services::Rule, nil]
        #
        def from_id(id)
          return nil unless Mihari::Rule.exists?(id)

          Services::RuleProxy.from_model Mihari::Rule.find(id)
        end

        #
        # @param [String] path_or_id Path to YAML file or YAML string or ID of a rule in the database
        #
        # @return [Mihari::Services::Rule]
        #
        def from_path_or_id(path_or_id)
          rule = from_path(path_or_id)
          return rule unless rule.nil?

          rule = from_id(path_or_id)
          return rule unless rule.nil?

          raise ArgumentError, "#{path_or_id} does not exist"
        end
      end
    end
  end
end
