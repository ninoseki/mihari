# frozen_string_literal: true

module Mihari
  module Schemas
    module Enrichers
      IPInfo = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("ipinfo"))
        optional(:api_key).value(:string)
        optional(:options).hash(Options)
      end

      Whois = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("whois"))
        optional(:options).hash(Options)
      end

      Shodan = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("shodan"))
        optional(:options).hash(Options)
      end

      GooglePublicDNS = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("google_public_dns"))
        optional(:options).hash(Options)
      end
    end
  end
end
