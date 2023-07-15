# frozen_string_literal: true

module Mihari
  module Analyzers
    class Crtsh < Base
      # @return [Boolean]
      attr_reader :exclude_expired

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [Bool] exclude_expired
      #
      def initialize(query, options: nil, exclude_expired: true)
        super(query, options: options)

        @exclude_expired = exclude_expired
      end

      def artifacts
        results = search
        results.map do |result|
          values = result["name_value"].to_s.lines.map(&:chomp)
          values.map do |value|
            Artifact.new(data: value, source: source, metadata: result)
          end
        end.flatten
      end

      private

      #
      # @return [Mihari::Clients::Crtsh]
      #
      def client
        @client ||= Mihari::Clients::Crtsh.new
      end

      #
      # Search
      #
      # @return [Array<Hash>]
      #
      def search
        exclude = exclude_expired ? "expired" : nil
        client.search(query, exclude: exclude)
      end
    end
  end
end
