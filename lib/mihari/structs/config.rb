# frozen_string_literal: true

module Mihari
  module Structs
    class Config < Dry::Struct
      attribute :name, Types::String
      attribute :type, Types::String
      attribute :is_configured, Types::Bool
      attribute :values, Types.Array(Types::Hash).optional

      #
      # @return [String]
      #
      def name
        attributes[:name]
      end

      #
      # @return [String]
      #
      def type
        attributes[:type]
      end

      #
      # @return [Boolean]
      #
      def is_configured
        attributes[:is_configured]
      end

      #
      # @return [Array<Hash>]
      #
      def values
        attributes[:values]
      end

      #
      # @param [Class<Mihari::Analyzers::Base>, Class<Mihari::Emitters::Base>] klass
      #
      # @return [Mihari::Structs::Config, nil] config
      #
      def self.from_class(klass)
        return nil if klass == Mihari::Analyzers::Rule

        name = klass.to_s.split("::").last.to_s

        is_analyzer = klass.ancestors.include?(Mihari::Analyzers::Base)
        is_emitter = klass.ancestors.include?(Mihari::Emitters::Base)
        is_enricher = klass.ancestors.include?(Mihari::Enrichers::Base)

        type = "Analyzer"
        type = "Emitter" if is_emitter
        type = "Enricher" if is_enricher

        begin
          instance = is_analyzer ? klass.new("dummy") : klass.new
          is_configured = instance.configured?
          values = instance.configuration_values

          new(name: name, values: values, is_configured: is_configured, type: type)
        rescue ArgumentError => _e
          nil
        end
      end
    end
  end
end
