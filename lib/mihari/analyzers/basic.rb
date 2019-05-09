# frozen_string_literal: true

module Mihari
  module Analyzers
    class Basic < Base
      attr_reader :title
      attr_reader :description
      attr_reader :artifacts
      attr_reader :tags

      def initialize(title:, description:, artifacts:, tags: [])
        super()

        @title = title
        @description = description
        @artifacts = artifacts
        @tags = tags
      end
    end
  end
end
