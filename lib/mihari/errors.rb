# frozen_string_literal: true

module Mihari
  class Error < StandardError; end

  class ValueError < Error; end

  class RetryableError < Error; end

  class ConfigurationError < Error; end

  class IntegrityError < Error; end

  # errors for HTTP interactions
  class HTTPError < Error; end

  class NetworkError < HTTPError; end

  class TimeoutError < HTTPError; end

  #
  # HTTP status code error
  #
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

  #
  # (dry-schema) Schema validation error
  #
  class ValidationError < Error
    attr_reader :errors

    #
    # @param [String] msg
    # @param [Dry::Schema::MessageSet] errors
    #
    def initialize(msg, errors)
      super(msg)

      @errors = errors
    end
  end
end
