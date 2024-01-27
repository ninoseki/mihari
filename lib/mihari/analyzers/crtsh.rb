# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # crt.sh analyzer
    #
    class Crtsh < Base
      # @return [Boolean]
      attr_reader :exclude_expired

      # @return [String, nil]
      attr_reader :match

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [Bool] exclude_expired
      # @param [String, nil] match
      #
      def initialize(query, options: nil, exclude_expired: true, match: nil)
        super(query, options:)

        @exclude_expired = exclude_expired
        @match = match
      end

      def artifacts
        exclude = exclude_expired ? "expired" : nil
        client.search(query, exclude:, match:).map do |result|
          values = result["name_value"].to_s.lines.map(&:chomp).reject { |value| value.starts_with?("*.") }
          values.map { |value| Models::Artifact.new(data: value, metadata: result) }
        end.flatten
      end

      private

      #
      # @return [Mihari::Clients::Crtsh]
      #
      def client
        Mihari::Clients::Crtsh.new(timeout:)
      end
    end
  end
end
