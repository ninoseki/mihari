# frozen_string_literal: true

module Mihari
  module Analyzers
    class Basic < Base
      attr_reader :title
      attr_reader :description
      attr_reader :artifacts

      def initialize(title:, description:, artifacts:)
        super()

        @title = title
        @description = description
        @artifacts = artifacts
      end
    end
  end
end
