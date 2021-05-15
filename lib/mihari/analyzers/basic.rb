# frozen_string_literal: true

module Mihari
  module Analyzers
    class Basic < Base
      attr_reader :title, :description, :artifacts, :source, :tags

      def initialize(title:, description:, artifacts:, source:, tags: [])
        super()

        @title = title
        @description = description
        @artifacts = artifacts
        @source = source
        @tags = tags
      end
    end
  end
end
