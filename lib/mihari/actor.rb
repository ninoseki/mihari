# frozen_string_literal: true

module Mihari
  #
  # Yet another base service class for Analyzer, Emitter and Enricher
  #
  class Actor
    include Dry::Monads[:result, :try]

    include Concerns::Configurable
    include Concerns::Retriable

    # @return [Hash]
    attr_reader :options

    #
    # @param [Hash, nil] options
    #
    def initialize(options: nil)
      super()

      @options = options || {}
    end

    #
    # @return [Integer]
    #
    def retry_interval
      options[:retry_interval] || Mihari.config.retry_interval
    end

    #
    # @return [Boolean]
    #
    def retry_exponential_backoff
      options[:retry_exponential_backoff] || Mihari.config.retry_exponential_backoff
    end

    #
    # @return [Integer]
    #
    def retry_times
      options[:retry_times] || Mihari.config.retry_times
    end

    #
    # @return [Integer, nil]
    #
    def timeout
      options[:timeout]
    end

    def validate_configuration!
      return if configured?

      message = "#{self.class.type.capitalize}:#{self.class.key} is not configured correctly"
      detail = self.class.configuration_keys.map { |key| "#{key.upcase} is missing" }

      raise ConfigurationError.new(message, detail)
    end

    def call(*args, **kwargs)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def result(...)
      Try[StandardError] do
        retry_on_error(times: retry_times, interval: retry_interval, exponential_backoff: retry_exponential_backoff) do
          call(...)
        end
      end.to_result
    end

    class << self
      #
      # @return [String]
      #
      def key
        to_s.split("::").last.downcase
      end

      #
      # @return [Array<String>, nil]
      #
      def key_aliases
        nil
      end

      #
      # @return [Array<String>]
      #
      def keys
        ([key] + [key_aliases]).flatten.compact.map(&:downcase)
      end

      def type
        return "analyzer" if ancestors.include?(Mihari::Analyzers::Base)
        return "emitter" if ancestors.include?(Mihari::Emitters::Base)
        return "enricher" if ancestors.include?(Mihari::Enrichers::Base)

        nil
      end
    end
  end
end
