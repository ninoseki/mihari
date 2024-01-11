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

      joined = self.class.configuration_keys.map(&:upcase).join(", ")
      be = (self.class.configuration_keys.length > 1) ? "are" : "is"
      message = "#{self.class.key} is not configured correctly. #{joined} #{be} missing."
      raise ConfigurationError, message
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
    end
  end
end
