# frozen_string_literal: true

module Mihari
  module Analyzers
    class Basic < Base
      attr_accessor :title
      attr_reader :description
      attr_reader :artifacts
      attr_reader :tags

      def initialize(title:, description:, artifacts:, tags: [])
        @title = title
        @description = description
        @artifacts = artifacts
        @tags = tags
      end
    end
  end
end
