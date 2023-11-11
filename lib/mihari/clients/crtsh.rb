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
        super(base_url, headers: headers, timeout: timeout)
      end

      #
      # Search crt.sh by a given identity
      #
      # @param [String] identity
      # @param [String, nil] match "=", "ILIKE", "LIKE", "single", "any" or nil
      # @param [String, nil] exclude "expired" or nil
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def search(identity, match: nil, exclude: nil)
        params = { identity: identity, match: match, exclude: exclude, output: "json" }.compact

        # @type [Array[Hash]]
        parsed = get_json("/", params: params)
        parsed.map do |result|
          values = result["name_value"].to_s.lines.map(&:chomp)
          values.map { |value| Models::Artifact.new(data: value, metadata: result) }
        end.flatten
      end
    end
  end
end
