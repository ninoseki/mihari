# frozen_string_literal: true

require "http"

module Mihari
  class Error < StandardError; end

  class ValueError < Error; end

  class ConfigurationError < Error; end

  class ResponseError < Error; end

  class AnalyzerError < Error
    # @return [StandardException, nil]
    attr_reader :cause

    #
    # @param [String] msg
    # @param [String] analyzer
    # @param [StandardException, nil] cause
    #
    def initialize(msg, analyzer, cause: nil)
      super("#{msg} (from #{analyzer})")

      @cause = cause
      set_backtrace(cause.backtrace) if cause
    end

    def detail
      return nil unless cause.respond_to?(:detail)

      cause.detail
    end
  end

  class IntegrityError < Error; end

  #
  # HTTP status code error
  #
  class StatusCodeError < ::HTTP::Error
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

    def detail
      { status_code: status_code, body: body }
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

    def detail
      errors.to_h
    end
  end
end
