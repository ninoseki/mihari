# frozen_string_literal: true

module Mihari
  module Analyzers
    # Censys Platform API analyzer
    class CensysV2 < Base
      attr_reader :query, :api_key, :organization_id

      def initialize(query, options: nil, api_key: nil, organization_id: nil)
        super(query, options:)
        @api_key = api_key || Mihari.config.censys_v2_api_key
        @organization_id = organization_id || Mihari.config.censys_v2_org_id
      end

      def artifacts
        client.search_with_pagination(query, pagination_limit:).flat_map(&:artifacts).uniq(&:data)
      end

      class << self
        def key
          "censys_v2"
        end
      end

      private

      def client
        Clients::CensysV2.new(
          api_key: api_key,
          organization_id: organization_id,
          pagination_interval: pagination_interval,
          timeout: timeout
        )
      end
    end
  end
end