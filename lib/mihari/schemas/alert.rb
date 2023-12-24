# frozen_string_literal: true

module Mihari
  module Schemas
    Alert = Dry::Schema.Params do
      required(:rule_id).value(:string)
      required(:artifacts).value(array[:string])
      optional(:source).value(:string)
    end

    #
    # Alert schema contract
    #
    class AlertContract < Dry::Validation::Contract
      params(Alert)
    end
  end
end
