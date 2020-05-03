# frozen_string_literal: true

module Mihari
  module Analyzers
    class Basic < Base
      attr_accessor :title
      attr_reader :description
      attr_reader :artifacts
      attr_reader :source
      attr_reader :tags

      def initialize(title:, description:, artifacts:, source:, tags: [])
        @title = title
        @description = description
        @artifacts = artifacts
        @source = source
        @tags = tags
      end
    end
  end
end
