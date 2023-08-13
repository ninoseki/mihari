# frozen_string_literal: true

module Mihari
  module Services
    class AlertProxy
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
        contract = Schemas::AlertContract.new
        result = contract.call(data)

        @data = result.to_h
        @errors = result.errors
      end

      def validate!
        return unless errors?

        Mihari.logger.error "Failed to parse the input as an alert:"
        Mihari.logger.error JSON.pretty_generate(errors.to_h)

        raise AlertValidationError, errors
      end

      def [](key)
        data key.to_sym
      end

      #
      # @return [String]
      #
      def rule_id
        @rule_id ||= data[:rule_id]
      end

      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        @artifacts ||= data[:artifacts].map do |data|
          artifact = Artifact.new(data: data)
          artifact.rule_id = rule_id
          artifact
        end.uniq(&:data).select(&:valid?)
      end

      #
      # @return [Mihari::Services::RuleProxy]
      #
      def rule
        @rule ||= Services::RuleProxy.from_model(Mihari::Rule.find(rule_id))
      end

      class << self
        #
        # Load rule from YAML string
        #
        # @param [String] yaml
        #
        # @return [Mihari::Services::Alert]
        #
        def from_yaml(yaml)
          Services::AlertProxy.new YAML.safe_load(yaml, permitted_classes: [Date, Symbol])
        rescue Psych::SyntaxError => e
          raise YAMLSyntaxError, e.message
        end

        # @param [String] path
        #
        # @return [Mihari::Services::Alert, nil]
        #
        def from_path(path)
          return nil unless Pathname(path).exist?

          from_yaml File.read(path)
        end
      end
    end
  end
end
