# frozen_string_literal: true

require "dry/schema"
require "dry/validation"
require "dry/types"

require "mihari/schemas/macros"

module Mihari
  module Types
    include Dry.Types()
  end

  DataTypes = Types::String.enum(*ALLOWED_DATA_TYPES)

  AnalyzerTypes = Types::String.enum(
    "binaryedge", "censys", "circl", "dnpedia", "dnstwister",
    "onyphe", "otx", "passivetotal", "pulsedive", "securitytrails",
    "shodan", "virustotal"
  )

  module Schemas
    Analyzer = Dry::Schema.Params do
      required(:analyzer).value(AnalyzerTypes)
      required(:query).value(:string)
    end

    Spyse = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("spyse"))
      required(:query).value(:string)
      required(:type).value(Types::String.enum("ip", "domain"))
    end

    ZoomEye = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("zoomeye"))
      required(:query).value(:string)
      required(:type).value(Types::String.enum("host", "web"))
    end

    Crtsh = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("crtsh"))
      required(:query).value(:string)
      optional(:exclude_expired).value(:bool).default(true)
    end

    Urlscan = Dry::Schema.Params do
      required(:analyzer).value(Types::String.enum("urlscan"))
      required(:query).value(:string)
      optional(:use_similarity).value(:bool).default(true)
    end

    Rule = Dry::Schema.Params do
      required(:title).value(:string)
      required(:description).value(:string)

      optional(:tags).value(array[:string]).default([])
      optional(:id).value(:string)

      optional(:author).value(:string)
      optional(:created_on).value(:date)
      optional(:updated_on).value(:date)

      required(:queries).value(:array).each { Analyzer | Spyse | ZoomEye | Urlscan | Crtsh }

      optional(:allowed_data_types).value(array[DataTypes]).default(ALLOWED_DATA_TYPES)
      optional(:disallowed_data_values).value(array[:string]).default([])
    end

    class RuleContract < Dry::Validation::Contract
      params(Rule)

      rule(:disallowed_data_values) do
        value.each do |v|
          Regexp.compile v
        rescue RegexpError
          key.failure("#{value} is not a valid regexp.")
        end
      end
    end
  end
end
