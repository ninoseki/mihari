# frozen_string_literal: true

module Mihari
  module Schemas
    #
    # Analyzer schemas
    #
    module Analyzers
      extend Concerns::Orrable

      # Analyzer with API key and pagination
      [
        Mihari::Analyzers::BinaryEdge.keys,
        Mihari::Analyzers::GreyNoise.keys,
        Mihari::Analyzers::Onyphe.keys,
        Mihari::Analyzers::Shodan.keys,
        Mihari::Analyzers::Urlscan.keys,
        Mihari::Analyzers::VirusTotalIntelligence.keys
      ].each do |keys|
        key = keys.first
        const_set(key.upcase, Dry::Schema.Params do
          required(:analyzer).value(Types::String.enum(*keys))
          required(:query).value(:string)
          optional(:api_key).value(:string)
          optional(:options).hash(AnalyzerPaginationOptions)
        end)
      end

      # Analyzer with API key
      [
        Mihari::Analyzers::OTX.keys,
        Mihari::Analyzers::Pulsedive.keys,
        Mihari::Analyzers::VirusTotal.keys,
        Mihari::Analyzers::SecurityTrails.keys
      ].each do |keys|
        key = keys.first
        const_set(key.upcase, Dry::Schema.Params do
          required(:analyzer).value(Types::String.enum(*keys))
          required(:query).value(:string)
          optional(:api_key).value(:string)
          optional(:options).hash(AnalyzerOptions)
        end)
      end

      DNSTwister = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::DNSTwister.keys))
        required(:query).value(:string)
        optional(:options).hash(AnalyzerOptions)
      end

      Censys = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Censys.keys))
        required(:query).value(:string)
        optional(:id).value(:string)
        optional(:secret).value(:string)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      CIRCL = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::CIRCL.keys))
        required(:query).value(:string)
        optional(:username).value(:string)
        optional(:password).value(:string)
        optional(:options).hash(AnalyzerOptions)
      end

      Fofa = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Fofa.keys))
        required(:query).value(:string)
        optional(:api_key).value(:string)
        optional(:email).value(:string)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      PassiveTotal = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::PassiveTotal.keys))
        required(:query).value(:string)
        optional(:username).value(:string)
        optional(:api_key).value(:string)
        optional(:options).hash(AnalyzerOptions)
      end

      ZoomEye = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::ZoomEye.keys))
        required(:query).value(:string)
        required(:type).value(Types::String.enum("host", "web"))
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      Crtsh = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Crtsh.keys))
        required(:query).value(:string)
        optional(:exclude_expired).value(:bool).default(true)
        optional(:match).value(Types::String.enum("=", "ILIKE", "LIKE", "single", "any", "FTS")).default(nil)
        optional(:options).hash(AnalyzerOptions)
      end

      HunterHow = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::HunterHow.keys))
        required(:query).value(:string)
        required(:start_time).value(:date)
        required(:end_time).value(:date)
        optional(:api_key).value(:string)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      Feed = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Feed.keys))
        required(:query).value(:string)
        required(:selector).value(:string)
        optional(:method).value(Types::HTTPRequestMethods).default("GET")
        optional(:headers).value(:hash).default({})
        optional(:params).value(:hash)
        optional(:form).value(:hash)
        optional(:json).value(:hash)
        optional(:options).hash(AnalyzerOptions)
      end
    end

    Analyzer = Schemas::Analyzers.get_or_composition
  end
end
