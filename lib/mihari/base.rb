# frozen_string_literal: true

module Mihari
  #
  # Base class for Analyzer, Emitter and Enricher
  #
  class Base
    # @return [Hash]
    attr_reader :options

    #
    # @param [Hash, nil] options
    #
    def initialize(*_args, options: nil, **_kwargs)
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
        ([class_key] + [class_key_aliases]).flatten.compact
      end
    end
  end
end
