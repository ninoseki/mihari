# frozen_string_literal: true

module Mihari
  #
  # Base class for Analyzer, Emitter and Enricher
  #
  class Actor
    include Dry::Monads[:result, :try]

    include Mixins::Configurable
    include Mixins::Retriable

    # @return [Hash]
    attr_reader :options

    #
    # @param [Hash, nil] options
    #
    def initialize(options: nil)
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

      joined = configuration_keys.join(", ")
      be = (configuration_keys.length > 1) ? "are" : "is"
      message = "#{self.class.class_key} is not configured correctly. #{joined} #{be} missing."
      raise ConfigurationError, message
    end

    class << self
      #
      # @return [String]
      #
      def class_key
        to_s.split("::").last
      end

      #
      # @return [Array<String>, nil]
      #
      def class_key_aliases
        nil
      end

      #
      # @return [Array<String>]
      #
      def class_keys
        ([class_key] + [class_key_aliases]).flatten.compact.map(&:downcase)
      end
    end
  end
end
