# frozen_string_literal: true

module Mihari
  module Structs
    class Config < Dry::Struct
      # @!attribute [r] name
      #   @return [String]
      attribute :name, Types::String

      # @!attribute [r] type
      #   @return [String]
      attribute :type, Types::String

      # @!attribute [r] is_configured
      #   @return [Boolean]
      attribute :is_configured, Types::Bool

      # @!attribute [r] values
      #   @return [Array<Hash>, nil]
      attribute :values, Types.Array(Types::Hash).optional

      class << self
        #
        # Get a type of a class
        #
        # @param [Class<Mihari::Analyzers::Base>, Class<Mihari::Emitters::Base>, Class<Mihari::Enrichers::Base>] klass
        #
        # @return [String, nil]
        #
        def get_type(klass)
          return "Analyzer" if klass.ancestors.include?(Mihari::Analyzers::Base)
          return "Emitter" if klass.ancestors.include?(Mihari::Emitters::Base)
          return "Enricher" if klass.ancestors.include?(Mihari::Enrichers::Base)

          nil
        end

        #
        # Get a dummy instance
        #
        # @param [Class<Mihari::Analyzers::Base>, Class<Mihari::Emitters::Base>, Class<Mihari::Enrichers::Base>] klass
        #
        # @return [Mihari::Analyzers::Base, Mihari::Emitter::Base, Mihari::Enricher::Base] dummy
        #
        def get_dummy(klass)
          type = get_type(klass)
          case type
          when "Analyzer"
            klass.new("dummy")
          when "Emitter"
            klass.new(rule: nil)
          else
            klass.new
          end
        end

        #
        # @param [Class<Mihari::Analyzers::Base>, Class<Mihari::Emitters::Base>, Class<Mihari::Enrichers::Base>] klass
        #
        # @return [Mihari::Structs::Config, nil] config
        #
        def from_class(klass)
          return nil if klass == Mihari::Rule

          type = get_type(klass)
          return nil if type.nil?

          begin
            instance = get_dummy(klass)
            new(
              name: klass.to_s.split("::").last.to_s,
              values: instance.configuration_values,
              is_configured: instance.configured?,
              type: type
            )
          rescue ArgumentError
            nil
          end
        end
      end
    end
  end
end
