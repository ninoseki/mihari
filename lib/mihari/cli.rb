# frozen_string_literal: true

require "json"

module Mihari
  class BasicAnalyzer < Analyzer
    attr_reader :title
    attr_reader :description

    def initialize(title:, description:, artifacts:)
      super()

      @title = title
      @description = description
      @artifacts = artifacts
    end

    def artifacts
      @artifacts.map { |data| Artifact.new data }
    end
  end

  class CLI
    REQUIRED_ATTRIBUTES = %w(title description artifacts).freeze

    def initialize(input)
      @input = input
    end

    def json
      @json ||= parse_as_json(@input)
    end

    def valid?
      return false unless json

      REQUIRED_ATTRIBUTES.all? { |attr| json.key? attr }
    end

    def start
      raise ArgumentError, "Input not found: please give an input in a JSON format" unless @input
      raise ArgumentError, "Invalid input format" unless valid?

      title = json.dig("title")
      description = json.dig("description")
      artifacts = json.dig("artifacts")

      basic_analyzer = BasicAnalyzer.new(title: title, description: description, artifacts: artifacts)
      basic_analyzer.run
    end

    def self.start(input)
      new(input).start
    end

    private

    def parse_as_json(input)
      JSON.parse input
    rescue JSON::ParserError => _
      nil
    end
  end
end
