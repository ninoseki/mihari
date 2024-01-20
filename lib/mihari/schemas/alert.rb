# frozen_string_literal: true

module Mihari
  module Schemas
    Alert = Dry::Schema.Params do
      required(:rule_id).filled(:string)
      required(:artifacts).array { filled(:string) }
      optional(:source).filled(:string)
    end

    #
    # Alert schema contract
    #
    class AlertContract < Dry::Validation::Contract
      params(Alert)
    end
  end
end
