# frozen_string_literal: true

module Mihari
  class Error < StandardError; end

  class InvalidInputError < Error; end

  class InvalidArtifactFormatError < Error; end

  class RetryableError < Error; end

  class FileNotFoundError < Error; end

  class FeedParseError < Error; end

  class RuleValidationError < Error; end

  class AlertValidationError < Error; end

  class YAMLSyntaxError < Error; end

  class ConfigurationError < Error; end

  # errors for HTTP interactions
  class HTTPError < Error; end

  class NetworkError < HTTPError; end

  class TimeoutError < HTTPError; end

  class SSLError < HTTPError; end

  class StatusCodeError < HTTPError
    # @return [Integer]
    attr_reader :status_code

    # @return [String, nil]
    attr_reader :body

    #
    # @param [String] msg
    # @param [Integer] status_code
    # @param [String, nil] body
    #
    def initialize(msg, status_code, body)
      super(msg)

      @status_code = status_code
      @body = body
    end
  end
end
