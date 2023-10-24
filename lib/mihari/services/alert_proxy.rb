# frozen_string_literal: true

require "json"

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

        validate!
      end

      #
      # @return [Boolean]
      #
      def errors?
        return false if @errors.nil?

        !@errors.empty?
      end

      def validate!
        contract = Schemas::AlertContract.new
        result = contract.call(data)

        @data = result.to_h
        @errors = result.errors

        raise ValidationError.new("Validation failed", errors) if errors?
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
      # @return [Array<Mihari::Models::Artifact>]
      #
      def artifacts
        @artifacts ||= data[:artifacts].map do |data|
          artifact = Models::Artifact.new(data: data)
          artifact.rule_id = rule_id
          artifact
        end.uniq(&:data).select(&:valid?)
      end

      #
      # @return [Mihari::Services::RuleProxy]
      #
      def rule
        @rule ||= Services::RuleProxy.new(Mihari::Models::Rule.find(rule_id).data)
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
          new YAML.safe_load(yaml, permitted_classes: [Date, Symbol])
        end
      end
    end
  end
end
