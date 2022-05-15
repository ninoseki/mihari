# frozen_string_literal: true

module Mihari
  module Schemas
    Emitter = Dry::Schema.Params do
      required(:emitter).value(Types::EmitterTypes)
    end

    MISP = Dry::Schema.Params do
      required(:emitter).value(Types::String.enum("misp"))
      optional(:api_endpoint).value(:string)
      optional(:api_key).value(:string)
    end

    TheHive = Dry::Schema.Params do
      required(:emitter).value(Types::String.enum("the_hive"))
      optional(:api_endpoint).value(:string)
      optional(:api_key).value(:string)
      optional(:api_version).value(Types::String.enum("v4", "v5")).default("v4")
    end

    Slack = Dry::Schema.Params do
      required(:emitter).value(Types::String.enum("slack"))
      optional(:webhook_url).value(:string)
      optional(:channel).value(:string)
    end

    HTTP = Dry::Schema.Params do
      required(:emitter).value(Types::String.enum("http"))
      required(:url).value(:string)
      optional(:http_request_method).value(Types::HTTPRequestMethods).default("POST")
      optional(:http_request_headers).value(:hash).default({})
      optional(:template).value(:string)
    end
  end
end
