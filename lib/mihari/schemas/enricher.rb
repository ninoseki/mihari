# frozen_string_literal: true

module Mihari
  module Schemas
    #
    # Enricher schemas
    #
    module Enrichers
      extend Concerns::Orrable

      MMDB = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::MMDB.class_keys))
        optional(:options).hash(Options)
      end

      Whois = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::Whois.class_keys))
        optional(:options).hash(Options)
      end

      Shodan = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::Shodan.class_keys))
        optional(:options).hash(Options)
      end

      GooglePublicDNS = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum(*Mihari::Enrichers::GooglePublicDNS.class_keys))
        optional(:options).hash(Options)
      end
    end

    Enricher = Schemas::Enrichers.get_or_composition
  end
end
