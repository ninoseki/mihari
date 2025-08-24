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
        Mihari::Analyzers::GreyNoise.keys,
        Mihari::Analyzers::Onyphe.keys,
        Mihari::Analyzers::Shodan.keys,
        Mihari::Analyzers::Validin.keys,
        Mihari::Analyzers::VirusTotalIntelligence.keys
      ].each do |keys|
        key = keys.first
        const_set(key.upcase, Dry::Schema.Params do
          required(:analyzer).value(Types::String.enum(*keys))
          required(:query).filled(:string)
          optional(:api_key).filled(:string)
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
          required(:query).filled(:string)
          optional(:api_key).filled(:string)
          optional(:options).hash(AnalyzerOptions)
        end)
      end

      DNSTwister = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::DNSTwister.keys))
        required(:query).filled(:string)
        optional(:options).hash(AnalyzerOptions)
      end

      Censys = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Censys.keys))
        required(:query).filled(:string)
        optional(:id).filled(:string)
        optional(:secret).filled(:string)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      CIRCL = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::CIRCL.keys))
        required(:query).filled(:string)
        optional(:username).filled(:string)
        optional(:password).filled(:string)
        optional(:options).hash(AnalyzerOptions)
      end

      Fofa = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Fofa.keys))
        required(:query).filled(:string)
        optional(:api_key).filled(:string)
        optional(:email).filled(:string)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      PassiveTotal = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::PassiveTotal.keys))
        required(:query).filled(:string)
        optional(:username).filled(:string)
        optional(:api_key).filled(:string)
        optional(:options).hash(AnalyzerOptions)
      end

      Urlscan = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Urlscan.keys))
        required(:query).filled(:string)
        optional(:data_types).filled(array[Types::NetworkDataTypes]).default(Types::NetworkDataTypes.values)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      ZoomEye = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::ZoomEye.keys))
        required(:query).filled(:string)
        optional(:data_types).filled(array[Types::NetworkDataTypes]).default(Types::NetworkDataTypes.values)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      Crtsh = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Crtsh.keys))
        required(:query).filled(:string)
        optional(:exclude_expired).value(:bool).default(true)
        optional(:match).value(Types::String.enum("=", "ILIKE", "LIKE", "single", "any", "FTS")).default(nil)
        optional(:options).hash(AnalyzerOptions)
      end

      HunterHow = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::HunterHow.keys))
        required(:query).filled(:string)
        required(:start_time).value(:date)
        required(:end_time).value(:date)
        optional(:api_key).filled(:string)
        optional(:options).hash(AnalyzerPaginationOptions)
      end

      Feed = Dry::Schema.Params do
        required(:analyzer).value(Types::String.enum(*Mihari::Analyzers::Feed.keys))
        required(:query).filled(:string)
        required(:selector).filled(:string)
        optional(:method).value(Types::HTTPRequestMethods).default("GET")
        optional(:headers).filled(:hash)
        optional(:params).filled(:hash)
        optional(:form).filled(:hash)
        optional(:json).filled(:hash)
        optional(:options).hash(AnalyzerOptions)
      end
    end

    Analyzer = Schemas::Analyzers.compose_by_or
  end
end
