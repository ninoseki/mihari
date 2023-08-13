# frozen_string_literal: true

module Mihari
  module Schemas
    Alert = Dry::Schema.Params do
      required(:rule_id).value(:string)
      required(:artifacts).value(array[:string])
    end

    class AlertContract < Dry::Validation::Contract
      params(Alert)
    end
  end
end
