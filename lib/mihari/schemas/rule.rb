# frozen_string_literal: true

require "mihari/schemas/analyzer"
require "mihari/schemas/emitter"
require "mihari/schemas/enricher"

module Mihari
  module Schemas
    Rule = Dry::Schema.Params do
      required(:id).filled(:string)
      required(:title).filled(:string)
      required(:description).filled(:string)

      optional(:author).filled(:string)
      optional(:status).filled(:string)

      optional(:tags).array { filled(:string) }.default([])
      optional(:references).array { filled(:string) }
      optional(:related).array { filled(:string) }

      optional(:created_on).value(:date)
      optional(:updated_on).value(:date)

      required(:queries).array { Analyzer }
      optional(:emitters).array { Emitter }.default(DEFAULT_EMITTERS)
      optional(:enrichers).array { Enricher }.default(DEFAULT_ENRICHERS)

      optional(:data_types).filled(array[Types::DataTypes]).default(Types::DataTypes.values)

      optional(:falsepositives).array { filled(:string) }.default([])

      optional(:artifact_ttl).value(:integer)
    end

    #
    # Rule schema contract
    #
    class RuleContract < Dry::Validation::Contract
      include Mihari::Concerns::FalsePositiveValidatable

      params(Rule)

      rule(:falsepositives) do
        value.each do |v|
          key.failure("#{v} is not a valid format") unless valid_falsepositive?(v)
        end
      end

      rule(:emitters) do
        emitters = value.filter_map { |v| v[:emitter] }
        unless emitters.include?(Mihari::Emitters::Database.key)
          key.failure("Emitter:#{Mihari::Emitters::Database.key} should be included in emitters")
        end
      end
    end
  end
end
