# frozen_string_literal: true

module Mihari
  module Schemas
    #
    # Enricher schemas
    #
    module Enrichers
      extend Concerns::Orrable

      MMDB = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::MMDB.keys))
        optional(:options).hash(Options)
      end

      Whois = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::Whois.keys))
        optional(:options).hash(Options)
      end

      Shodan = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::Shodan.keys))
        optional(:options).hash(Options)
      end

      GooglePublicDNS = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::GooglePublicDNS.keys))
        optional(:options).hash(Options)
      end
    end

    Enricher = Schemas::Enrichers.compose_by_or
  end
end
