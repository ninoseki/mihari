# frozen_string_literal: true

module Mihari
  module Analyzers
    class DNPedia < Base
      param :query

      def artifacts
        search || []
      end

      private

      def client
        @client ||= Clients::DNPedia.new
      end

      #
      # Search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def search
        res = client.search(query)
        rows = res["rows"] || []
        rows.map do |row|
          data = [row["name"], row["zoneid"]].join(".")
          Artifact.new(data: data, source: source, metadata: row)
        end
      end
    end
  end
end
