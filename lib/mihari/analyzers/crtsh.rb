# frozen_string_literal: true

module Mihari
  module Analyzers
    class Crtsh < Base
      param :query

      option :exclude_expired, default: proc { true }

      # @return [Boolean]
      attr_reader :exclude_expired

      # @return [String]
      attr_reader :query

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
