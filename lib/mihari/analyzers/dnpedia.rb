# frozen_string_literal: true

require "dnpedia"

module Mihari
  module Analyzers
    class DNPedia < Base
      param :query
      option :title, default: proc { "DNPedia domain search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      def artifacts
        search || []
      end

      private

      def api
        @api ||= ::DNPedia::API.new
      end

      def search
        res = api.search(query)
        rows = res["rows"] || []
        rows.map do |row|
          [row["name"], row["zoneid"]].join(".")
        end
      end
    end
  end
end
