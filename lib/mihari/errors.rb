# frozen_string_literal: true

module Mihari
  class Error < StandardError; end

  class InvalidInputError < Error; end

  class RetryableError < Error; end

  class FileNotFoundError < Error; end

  class HttpError < Error; end

  class FeedParseError < Error; end

  class RuleValidationError < Error; end

  class ConfigurationError < Error; end
end
