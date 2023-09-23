# frozen_string_literal: true

require "date"

require "erb"
require "pathname"
require "yaml"

module Mihari
  module Services
    class AlertBuilder
      include Dry::Monads[:result]

      # @return [String]
      attr_reader :path

      #
      # Initialize
      #
      # @param [String] path
      #
      def initialize(path)
        @path = path
      end

      #
      # @return [Hash]
      #
      def data
        raise ArgumentError, "#{path} does not exist" unless Pathname(path).exist?

        YAML.safe_load(
          ERB.new(File.read(path)).result,
          permitted_classes: [Date, Symbol]
        )
      end

      def result
        Success AlertProxy.new(data)
      rescue StandardError => e
        Failure e
      end
    end
  end
end
