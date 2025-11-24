# frozen_string_literal: true

module Mihari
  module Schemas
    Options = Dry::Schema.Params do
      optional(:retry_times).value(:integer)
      optional(:retry_interval).value(:integer)
      optional(:retry_exponential_backoff).value(:bool)
      optional(:timeout).value(:integer)
    end

    ParallelOptions = Dry::Schema.Params do
      optional(:parallel).value(:bool)
    end

    IgnoreErrorOptions = Dry::Schema.Params do
      optional(:ignore_error).value(:bool)
    end

    PaginationOptions = Dry::Schema.Params do
      optional(:pagination_interval).value(:integer)
      optional(:pagination_limit).value(:integer)
    end

    AnalyzerOptions = Options & IgnoreErrorOptions & ParallelOptions

    AnalyzerPaginationOptions = AnalyzerOptions & PaginationOptions

    AnalyzerPaginationOptionsWithVersion = AnalyzerPaginationOptions & Dry::Schema.Params do
      optional(:version).value(Types::Coercible::Integer.enum(2, 3))
    end

    EmitterOptions = Options & ParallelOptions
  end
end
