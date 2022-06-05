# frozen_string_literal: true

module Mihari
  module Schemas
    Enricher = Dry::Schema.Params do
      required(:enricher).value(Types::EnricherTypes)
    end
  end
end
