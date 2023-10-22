# frozen_string_literal: true

module Mihari
  module Schemas
    module Emitters
      Database = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("database"))
        optional(:options).hash(Options)
      end

      MISP = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("misp"))
        optional(:url).value(:string)
        optional(:api_key).value(:string)
        optional(:options).hash(Options)
      end

      TheHive = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("thehive"))
        optional(:url).value(:string)
        optional(:api_key).value(:string)
        optional(:api_version).value(Types::String.enum("v4", "v5")).default("v4")
        optional(:options).hash(Options)
      end

      Slack = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("slack"))
        optional(:webhook_url).value(:string)
        optional(:channel).value(:string)
        optional(:options).hash(Options)
      end

      Webhook = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum("webhook"))
        required(:url).value(:string)
        optional(:method).value(Types::HTTPRequestMethods).default("POST")
        optional(:headers).value(:hash).default({})
        optional(:template).value(:string)
        optional(:options).hash(Options)
      end
    end
  end
end
