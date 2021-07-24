# frozen_string_literal: true

require "dry/schema"
require "dry/validation"

require "mihari/schemas/macros"

module Mihari
  module Schemas
    AnalyzerRun = Dry::Schema.Params do
      required(:title).value(:string)
      required(:description).value(:string)
      required(:source).value(:string)
      required(:artifacts).value(array[:string])

      optional(:tags).value(array[:string]).default([])
      optional(:ignoreOldArtifacts).value(:bool).default(false)
      optional(:ignoreThreshold).value(:integer).default(0)
    end

    class AnalyzerRunContract < Dry::Validation::Contract
      params(AnalyzerRun)
    end
  end
end
