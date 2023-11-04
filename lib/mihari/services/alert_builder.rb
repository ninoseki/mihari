# frozen_string_literal: true

require "date"

require "erb"
require "pathname"
require "yaml"

module Mihari
  module Services
    #
    # Alert proxy
    #
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
      def initialize(**data)
        super()

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
      # @return [Mihari::Rule]
      #
      def rule
        @rule ||= [].tap do |out|
          data = Mihari::Models::Rule.find(rule_id).data
          out << Rule.new(**data)
        end.first
      end
    end

    #
    # Alert builder
    #
    class AlertBuilder < Service
      #
      # @param [String] path
      #
      # @return [Hash]
      #
      def data(path)
        raise ArgumentError, "#{path} does not exist" unless Pathname(path).exist?

        YAML.safe_load(
          ERB.new(File.read(path)).result,
          permitted_classes: [Date, Symbol]
        )
      end

      #
      # @param [String] path
      #
      # @return [Mihari::AlertProxy]
      #
      def call(path)
        AlertProxy.new(**data(path))
      end
    end
  end
end
