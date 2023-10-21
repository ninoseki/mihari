# frozen_string_literal: true

module Mihari
  module Schemas
    module Enrichers
      EnricherOptions = Dry::Schema.Params do
        optional(:retry_times).value(:integer).default(Mihari.config.retry_times)
        optional(:retry_interval).value(:integer).default(Mihari.config.retry_interval)
        optional(:retry_exponential_backoff).value(:bool).default(Mihari.config.retry_exponential_backoff)
        optional(:timeout).value(:integer)
      end

      IPInfo = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("ipinfo"))
        optional(:api_key).value(:string)
        optional(:options).hash(EnricherOptions)
      end

      Whois = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("whois"))
        optional(:options).hash(EnricherOptions)
      end

      Shodan = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("shodan"))
        optional(:options).hash(EnricherOptions)
      end

      GooglePublicDNS = Dry::Schema.Params do
        required(:enricher).value(Types::String.enum("google_public_dns"))
        optional(:options).hash(EnricherOptions)
      end
    end
  end
end
