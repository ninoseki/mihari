# frozen_string_literal: true

require "dnpedia"

module Mihari
  module Analyzers
    class DNPedia < Base
      param :query

      option :tags, default: proc { [] }

      def artifacts
        search || []
      end

      private

      def api
        @api ||= ::DNPedia::API.new
      end

      #
      # Search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def search
        res = api.search(query)
        rows = res["rows"] || []
        rows.map do |row|
          data = [row["name"], row["zoneid"]].join(".")
          Artifact.new(data: data, source: source, metadata: row)
        end
      end
    end
  end
end
