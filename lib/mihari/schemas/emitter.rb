# frozen_string_literal: true

module Mihari
  module Schemas
    #
    # Emitter schemas
    #
    module Emitters
      extend Concerns::Orrable

      Database = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Database.keys))
        optional(:options).hash(EmitterOptions)
      end

      MISP = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::MISP.keys))
        optional(:url).filled(:string)
        optional(:api_key).filled(:string)
        optional(:attribute_tags).array { filled(:string) }.default([])
        optional(:options).hash(EmitterOptions)
      end

      TheHive = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::TheHive.keys))
        optional(:url).filled(:string)
        optional(:api_key).filled(:string)
        optional(:observable_tags).array { filled(:string) }.default([])
        optional(:options).hash(EmitterOptions)
      end

      Yeti = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Yeti.keys))
        optional(:url).filled(:string)
        optional(:api_key).filled(:string)
        optional(:options).hash(EmitterOptions)
      end

      Slack = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Slack.keys))
        optional(:webhook_url).filled(:string)
        optional(:channel).filled(:string)
        optional(:options).hash(EmitterOptions)
      end

      Webhook = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Webhook.keys))
        required(:url).filled(:string)
        optional(:method).value(Types::HTTPRequestMethods).default("POST")
        optional(:headers).filled(:hash)
        optional(:template).filled(:string)
        optional(:options).hash(EmitterOptions)
      end
    end

    Emitter = Schemas::Emitters.compose_by_or
  end
end
