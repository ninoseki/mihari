# frozen_string_literal: true

module Mihari
  module Schemas
    AnalyzerOptions = Dry::Schema.Params do
      optional(:interval).value(:integer)
      optional(:retry_times).value(:integer).default(DEFAULT_RETRY_TIMES)
      optional(:retry_interval).value(:integer).default(DEFAULT_RETRY_INTERVAL)
    end

    AnalyzerWithoutAPIKey = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("dnstwister"))
      required(:query).value(:string)
      optional(:options).hash(AnalyzerOptions)
    end

    AnalyzerWithAPIKey = Dry::Schema.Params do
      required(:analyzer).value(
        Types::String.enum(
          "binaryedge",
          "greynoise",
          "onyphe",
          "otx",
          "pulsedive",
          "securitytrails",
          "shodan",
          "st",
          "urlscan",
          "virustotal_intelligence",
          "virustotal",
          "vt_intel",
          "vt"
        )
      )
      required(:query).value(:string)
      optional(:api_key).value(:string)
      optional(:options).hash(AnalyzerOptions)
    end

    Censys = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("censys"))
      required(:query).value(:string)
      optional(:id).value(:string)
      optional(:secret).value(:string)
      optional(:options).hash(AnalyzerOptions)
    end

    CIRCL = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("circl"))
      required(:query).value(:string)
      optional(:username).value(:string)
      optional(:password).value(:string)
      optional(:options).hash(AnalyzerOptions)
    end

    PassiveTotal = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("passivetotal", "pt"))
      required(:query).value(:string)
      optional(:username).value(:string)
      optional(:api_key).value(:string)
      optional(:options).hash(AnalyzerOptions)
    end

    ZoomEye = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("zoomeye"))
      required(:query).value(:string)
      required(:type).value(Types::String.enum("host", "web"))
      optional(:options).hash(AnalyzerOptions)
    end

    Crtsh = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("crtsh"))
      required(:query).value(:string)
      optional(:exclude_expired).value(:bool).default(true)
      optional(:options).hash(AnalyzerOptions)
    end

    Feed = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("feed"))
      required(:query).value(:string)
      required(:selector).value(:string)
      optional(:method).value(Types::HTTPRequestMethods).default("GET")
      optional(:headers).value(:hash).default({})
      optional(:params).value(:hash)
      optional(:data).value(:hash)
      optional(:json).value(:hash)
      optional(:options).hash(AnalyzerOptions)
    end
  end
end
