# frozen_string_literal: true

module Mihari
  module Clients
    #
    # crt.sh API client
    #
    class Crtsh < Base
      #
      # @param [String] base_url
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://crt.sh", headers: {}, timeout: nil)
        super
      end

      #
      # Search crt.sh by a given identity
      #
      # @param [String] identity
      # @param [String, nil] match "=", "ILIKE", "LIKE", "single", "any", "FTS" or nil
      # @param [String, nil] exclude "expired" or nil
      #
      # @return [Array<Hash>]
      #
      def search(identity, match: nil, exclude: nil)
        get_json("/", params: {identity:, match:, exclude:, output: "json"}.compact)
      end
    end
  end
end
