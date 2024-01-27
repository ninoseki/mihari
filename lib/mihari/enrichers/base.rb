# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # Base class for enrichers
    #
    class Base < Actor
      #
      # @param [Hash, nil] options
      #
      def initialize(options: nil)
        super(options:)
      end

      #
      # Enrich an artifact
      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Mihari::Models::Artifact]
      #
      def call(artifact)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Dry::Monads::Result::Success<Object>, Dry::Monads::Result::Failure]
      #
      def result(artifact)
        return unless callable?(artifact)

        result = Try[StandardError] do
          retry_on_error(times: retry_times, interval: retry_interval,
            exponential_backoff: retry_exponential_backoff) do
            call artifact
          end
        end.to_result

        if result.failure?
          Mihari.logger.warn("Enricher:#{self.class.key} for #{artifact.data.truncate(32)} failed: #{result.failure}")
        end

        result
      end

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Boolean]
      #
      def callable?(artifact)
        callable_data_type?(artifact) && callable_relationships?(artifact)
      end

      class << self
        def inherited(child)
          super
          Mihari.enrichers << child
        end
      end

      private

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Boolean]
      #
      def callable_data_type?(artifact)
        supported_data_types.include? artifact.data_type
      end

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Boolean]
      #
      def callable_relationships?(artifact)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # @return [Array<String>]
      #
      def supported_data_types
        []
      end
    end
  end
end
