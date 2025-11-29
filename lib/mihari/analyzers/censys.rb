# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Censys analyzer
    #
    class Censys < Base
      attr_reader :id, :secret, :pat, :organization_id, :version

      def initialize(query, version: nil, options: nil, id: nil, secret: nil, pat: nil, organization_id: nil)
        super(query, options:)

        @version = version || Mihari.config.censys_version

        # v2
        @id = id || Mihari.config.censys_id
        @secret = secret || Mihari.config.censys_secret
        # v3
        @pat = pat || Mihari.config.censys_pat
        @organization_id = organization_id || Mihari.config.censys_organization_id
      end

      def artifacts
        client.search_with_pagination(query, pagination_limit:).flat_map do |res|
          res.artifacts
        end.uniq(&:data)
      end

      def configured?
        case version
        when 2
          v2_configured?
        when 3
          v3_configured?
        else
          false
        end
      end

      private

      def client
        case version
        when 2
          v2_client
        when 3
          v3_client
        else
          raise "Unsupported Censys version: #{version}"
        end
      end

      def v3_client
        Clients::Censys::V3.new(
          pat:,
          organization_id:,
          pagination_interval:,
          timeout:
        )
      end

      def v2_client
        Clients::Censys::V2.new(
          id:,
          secret:,
          pagination_interval:,
          timeout:
        )
      end

      def v2_configured?
        id? && secret?
      end

      def v3_configured?
        pat? && organization_id?
      end

      def id?
        !id.nil?
      end

      def secret?
        !secret.nil?
      end

      def pat?
        !pat.nil?
      end

      def organization_id?
        !organization_id.nil?
      end
    end
  end
end
