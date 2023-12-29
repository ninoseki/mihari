# frozen_string_literal: true

require "mihari/schemas/analyzer"
require "mihari/schemas/emitter"
require "mihari/schemas/enricher"

module Mihari
  module Schemas
    Rule = Dry::Schema.Params do
      required(:id).value(:string)
      required(:title).value(:string)
      required(:description).value(:string)

      optional(:tags).value(array[:string]).default([])

      optional(:author).value(:string)
      optional(:references).value(array[:string])
      optional(:related).value(array[:string])
      optional(:status).value(:string)

      optional(:created_on).value(:date)
      optional(:updated_on).value(:date)

      required(:queries).value(:array).each { Analyzer } # rubocop:disable Lint/Void

      optional(:emitters).value(:array).each { Emitter }.default(DEFAULT_EMITTERS) # rubocop:disable Lint/Void
      optional(:enrichers).value(:array).each { Enricher }.default(DEFAULT_ENRICHERS) # rubocop:disable Lint/Void

      optional(:data_types).value(array[Types::DataTypes]).default(Mihari::Types::DataTypes.values)
      optional(:falsepositives).value(array[:string]).default([])

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
          key.failure("#{v} is not a valid format.") unless valid_falsepositive?(v)
        end
      end
    end
  end
end
