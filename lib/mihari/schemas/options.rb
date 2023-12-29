# frozen_string_literal: true

module Mihari
  module Schemas
    Options = Dry::Schema.Params do
      optional(:retry_times).value(:integer).default(Mihari.config.retry_times)
      optional(:retry_interval).value(:integer).default(Mihari.config.retry_interval)
      optional(:retry_exponential_backoff).value(:bool).default(Mihari.config.retry_exponential_backoff)
      optional(:timeout).value(:integer)
    end

    IgnoreErrorOptions = Dry::Schema.Params do
      optional(:ignore_error).value(:bool).default(Mihari.config.ignore_error)
    end

    ParallelOptions = Dry::Schema.Params do
      optional(:parallel).value(:bool).default(Mihari.config.parallel)
    end

    AnalyzerOptions = Options | IgnoreErrorOptions | ParallelOptions

    PaginationOptions = Dry::Schema.Params do
      optional(:pagination_interval).value(:integer).default(Mihari.config.pagination_interval)
      optional(:pagination_limit).value(:integer).default(Mihari.config.pagination_limit)
    end

    AnalyzerPaginationOptions = AnalyzerOptions | PaginationOptions
  end
end
