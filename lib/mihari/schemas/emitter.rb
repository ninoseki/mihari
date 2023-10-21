# frozen_string_literal: true

module Mihari
  module Schemas
    module Emitters
      EmitterOptions = Dry::Schema.Params do
        optional(:retry_times).value(:integer).default(Mihari.config.retry_times)
        optional(:retry_interval).value(:integer).default(Mihari.config.retry_interval)
        optional(:retry_exponential_backoff).value(:bool).default(Mihari.config.retry_exponential_backoff)
        optional(:timeout).value(:integer)
      end

      Database = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("database"))
        optional(:options).hash(EmitterOptions)
      end

      MISP = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("misp"))
        optional(:url).value(:string)
        optional(:api_key).value(:string)
        optional(:options).hash(EmitterOptions)
      end

      TheHive = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("the_hive"))
        optional(:url).value(:string)
        optional(:api_key).value(:string)
        optional(:api_version).value(Types::String.enum("v4", "v5")).default("v4")
        optional(:options).hash(EmitterOptions)
      end

      Slack = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("slack"))
        optional(:webhook_url).value(:string)
        optional(:channel).value(:string)
        optional(:options).hash(EmitterOptions)
      end

      Webhook = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("webhook"))
        required(:url).value(:string)
        optional(:method).value(Types::HTTPRequestMethods).default("POST")
        optional(:headers).value(:hash).default({})
        optional(:template).value(:string)
        optional(:options).hash(EmitterOptions)
      end
    end
  end
end
