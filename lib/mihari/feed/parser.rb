require "jr/cli/core_ext"

module Mihari
  module Feed
    class Parser
      attr_reader :data

      #
      # @param [Array<Hash>, Array<Array<String>>] data
      #
      def initialize(data)
        @data = data
      end

      #
      # Parse data by selector
      #
      # @param [String] selector
      #
      # @return [Array<String>]
      #
      def parse(selector)
        parsed = data.instance_eval(selector)

        raise FeedParseError unless parsed.is_a?(Array) || parsed.is_a?(Enumerator)
        raise FeedParseError unless parsed.all?(String)

        parsed.to_a
      end
    end
  end
end
