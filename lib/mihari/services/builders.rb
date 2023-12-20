# frozen_string_literal: true

module Mihari
  module Services
    #
    # Rule builder
    #
    class RuleBuilder < Service
      # @return [String]
      attr_reader :path_or_id

      #
      # @param [String] path_or_id
      #
      # @return [Hash]
      #
      def data
        result = Try { Mihari::Models::Rule.find path_or_id }.to_result
        return result.value! if result.success?

        raise ArgumentError, "#{path_or_id} does not exist" unless Pathname(path_or_id).exist?

        YAML.safe_load(
          ERB.new(File.read(path_or_id)).result,
          permitted_classes: [Date, Symbol]
        )
      end

      #
      # @param [String] path_or_id
      #
      # @return [Mihari::Rule]
      #
      def call(path_or_id)
        @path_or_id = path_or_id

        Rule.new(**data)
      end
    end
  end
end
