# frozen_string_literal: true

module Mihari
  module Analyzers
    class Basic < Base
      attr_reader :title
      attr_reader :description

      def initialize(title:, description:, artifacts:)
        super()

        @title = title
        @description = description
        @artifacts = artifacts
      end

      def artifacts
        @artifacts.map { |artifact| Artifact.new artifact }
      end
    end
  end
end
