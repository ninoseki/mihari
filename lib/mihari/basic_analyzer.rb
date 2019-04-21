# frozen_string_literal: true

module Mihari
  class BasicAnalyzer < Analyzer
    attr_reader :title
    attr_reader :description

    def initialize(title:, description:, artifacts:)
      @title = title
      @description = description
      @artifacts = artifacts
    end

    def artifacts
      @artifacts.map { |param| Artifact.new param }
    end
  end
end
