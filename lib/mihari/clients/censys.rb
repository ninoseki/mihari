# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    class Censys < Base
      #
      # @param [String] base_url
      # @param [String] id
      # @param [String] secret
      # @param [Hash] headers
      #
      def initialize(base_url = "https://search.censys.io", id:, secret:, headers: {})
        raise(ArgumentError, "'id' argument is required") if id.nil?
        raise(ArgumentError, "'secret' argument is required") if secret.nil?

        headers["authorization"] = "Basic #{Base64.strict_encode64("#{id}:#{secret}")}"

        super(base_url, headers: headers)
      end

      #
      # Search current index.
      #
      # Searches the given index for all records that match the given query.
      # For more details, see our documentation: https://search.censys.io/api/v2/docs
      #
      # @param [String] query the query to be executed.
      # @params [Integer, nil] per_page the number of results to be returned for each page.
      # @params [Integer, nil] cursor the cursor of the desired result set.
      #
      # @return [Hash]
      #
      def search(query, per_page: nil, cursor: nil)
        params = { q: query, per_page: per_page, cursor: cursor }.compact
        res = get("/api/v2/hosts/search", params: params)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
