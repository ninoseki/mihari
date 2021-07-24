# frozen_string_literal: true

module Mihari
  module Controllers
    class AnalyzersController < BaseController
      post "/api/analyzer" do
        contract = Mihari::Schemas::AnalyzerRunContract.new
        result = contract.call(params)

        unless result.errors.empty?
          status 400

          return json(result.errors.to_h)
        end

        args = result.to_h

        ignore_old_artifacts = args[:ignoreOldArtifacts]
        ignore_threshold = args[:ignoreThreshold]

        analyzer = Mihari::Analyzers::Basic.new(
          title: args[:title],
          description: args[:description],
          source: args[:source],
          artifacts: args[:artifacts],
          tags: args[:tags]
        )
        analyzer.ignore_old_artifacts = ignore_old_artifacts
        analyzer.ignore_threshold = ignore_threshold

        analyzer.run

        status 201
        body ""
      end
    end
  end
end
