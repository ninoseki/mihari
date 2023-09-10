# frozen_string_literal: true

module Mihari
  module Clients
    class Crtsh < Base
      #
      # @param [String] base_url
      # @param [Hash] headers
      #
      def initialize(base_url = "https://crt.sh", headers: {})
        super(base_url, headers: headers)
      end

      #
      # Search crt.sh by a given identity
      #
      # @param [String] identity
      # @param [String, nil] match "=", "ILIKE", "LIKE", "single", "any" or nil
      # @param [String, nil] exclude "expired" or nil
      #
      # @return [Array<Mihari::Artifact>]
      #
      def search(identity, match: nil, exclude: nil)
        params = { identity: identity, match: match, exclude: exclude, output: "json" }.compact

        res = get("/", params: params)
        parsed = JSON.parse(res.body.to_s)

        parsed.map do |result|
          values = result["name_value"].to_s.lines.map(&:chomp)
          values.map { |value| Artifact.new(data: value, metadata: result) }
        end.flatten
      end
    end
  end
end
