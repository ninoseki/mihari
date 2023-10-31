# frozen_string_literal: true

require "date"
require "erb"
require "pathname"
require "yaml"

module Mihari
  module Services
    #
    # Rule builder
    #
    class RuleBuilder < Service
      # @return [String]
      attr_reader :path_or_id

      #
      # Initialize
      #
      # @param [String] path_or_id
      #
      def initialize(path_or_id)
        super()

        @path_or_id = path_or_id
      end

      #
      # @return [Hash]
      #
      def data
        if Mihari::Models::Rule.exists?(path_or_id)
          rule = Mihari::Models::Rule.find(path_or_id)
          return rule.data
        end

        raise ArgumentError, "#{path_or_id} does not exist" unless Pathname(path_or_id).exist?

        YAML.safe_load(
          ERB.new(File.read(path_or_id)).result,
          permitted_classes: [Date, Symbol]
        )
      end

      def call
        Rule.new(**data)
      end
    end
  end
end
