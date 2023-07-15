# frozen_string_literal: true

module Mihari
  class Error < StandardError; end

  class InvalidInputError < Error; end

  class InvalidArtifactFormatError < Error; end

  class RetryableError < Error; end

  class FileNotFoundError < Error; end

  class FeedParseError < Error; end

  class RuleValidationError < Error; end

  class YAMLSyntaxError < Error; end

  class ConfigurationError < Error; end

  class HTTPError < Error; end

  class StatusCodeError < HTTPError; end

  class NetworkError < HTTPError; end

  class TimeoutError < HTTPError; end

  class SSLError < HTTPError; end
end
