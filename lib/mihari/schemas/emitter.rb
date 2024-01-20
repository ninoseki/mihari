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
        optional(:options).hash(Options)
      end

      MISP = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::MISP.keys))
        optional(:url).filled(:string)
        optional(:api_key).filled(:string)
        optional(:options).hash(Options)
      end

      TheHive = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::TheHive.keys))
        optional(:url).filled(:string)
        optional(:api_key).filled(:string)
        optional(:options).hash(Options)
      end

      Slack = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Slack.keys))
        optional(:webhook_url).filled(:string)
        optional(:channel).filled(:string)
        optional(:options).hash(Options)
      end

      Webhook = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Webhook.keys))
        required(:url).filled(:string)
        optional(:method).value(Types::HTTPRequestMethods).default("POST")
        optional(:headers).filled(:hash)
        optional(:template).filled(:string)
        optional(:options).hash(Options)
      end
    end

    Emitter = Schemas::Emitters.get_or_composition
  end
end
