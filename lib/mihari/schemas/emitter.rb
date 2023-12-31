# frozen_string_literal: true

module Mihari
  module Schemas
    #
    # Emitter schemas
    #
    module Emitters
      extend Concerns::Orrable

      Database = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Database.class_keys))
        optional(:options).hash(Options)
      end

      MISP = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::MISP.class_keys))
        optional(:url).value(:string)
        optional(:api_key).value(:string)
        optional(:options).hash(Options)
      end

      TheHive = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::TheHive.class_keys))
        optional(:url).value(:string)
        optional(:api_key).value(:string)
        optional(:options).hash(Options)
      end

      Slack = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Slack.class_keys))
        optional(:webhook_url).value(:string)
        optional(:channel).value(:string)
        optional(:options).hash(Options)
      end

      Webhook = Dry::Schema.Params do
        required(:emitter).value(Types::String.enum(*Mihari::Emitters::Webhook.class_keys))
        required(:url).value(:string)
        optional(:method).value(Types::HTTPRequestMethods).default("POST")
        optional(:headers).value(:hash).default({})
        optional(:template).value(:string)
        optional(:options).hash(Options)
      end
    end

    Emitter = Schemas::Emitters.get_or_composition
  end
end
