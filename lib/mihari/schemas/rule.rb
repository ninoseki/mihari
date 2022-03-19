# frozen_string_literal: true

module Mihari
  module Schemas
    AnalyzerOptions = Dry::Schema.Params do
      optional(:interval).value(:integer)
    end

    Analyzer = Dry::Schema.Params do
      required(:analyzer).value(Types::AnalyzerTypes)
      required(:query).value(:string)
      optional(:options).hash(AnalyzerOptions)
    end

    Spyse = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("spyse"))
      required(:query).value(:string)
      required(:type).value(Types::String.enum("ip", "domain"))
      optional(:options).hash(AnalyzerOptions)
    end

    ZoomEye = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("zoomeye"))
      required(:query).value(:string)
      required(:type).value(Types::String.enum("host", "web"))
      optional(:options).hash(AnalyzerOptions)
    end

    Crtsh = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("crtsh"))
      required(:query).value(:string)
      optional(:exclude_expired).value(:bool).default(true)
      optional(:options).hash(AnalyzerOptions)
    end

    Urlscan = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("urlscan"))
      required(:query).value(:string)
      optional(:options).hash(AnalyzerOptions)
    end

    Feed = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("feed"))
      required(:query).value(:string)
      required(:http_request_method).value(Types::FeedHttpRequestMethods).default("GET")
      required(:http_request_headers).value(:hash).default({})
      required(:http_request_payload).value(:hash).default({})
      required(:selector).value(:string)
      optional(:http_request_payload_type).value(Types::FeedHttpRequestPayloadTypes)
      optional(:options).hash(AnalyzerOptions)
    end

    Emitter = Dry::Schema.Params do
      required(:emitter).value(Types::EmitterTypes)
    end

    Rule = Dry::Schema.Params do
      required(:title).value(:string)
      required(:description).value(:string)

      optional(:tags).value(array[:string]).default([])
      optional(:id).value(:string)

      optional(:author).value(:string)
      optional(:created_on).value(:date)
      optional(:updated_on).value(:date)

      required(:queries).value(:array).each { Analyzer | Spyse | ZoomEye | Urlscan | Crtsh | Feed }

      required(:emitters).value(:array).each(Emitter).default(DEFAULT_EMITTERS)

      optional(:allowed_data_types).value(array[Types::DataTypes]).default(ALLOWED_DATA_TYPES)
      optional(:disallowed_data_values).value(array[:string]).default([])

      optional(:ignore_old_artifacts).value(:bool).default(false)
      optional(:ignore_threshold).value(:integer).default(0)
    end

    class RuleContract < Dry::Validation::Contract
      include Mihari::Mixins::DisallowedDataValue

      params(Rule)

      rule(:disallowed_data_values) do
        value.each do |v|
          unless valid_disallowed_data_value?(v)
            key.failure("#{v} is not a valid format.")
          end
        end
      end
    end
  end
end
