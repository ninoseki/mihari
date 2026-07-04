# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Censys analyzer
    #
    class Censys < Base
      # @return [String, nil]
      attr_reader :pat

      # @return [String, nil]
      attr_reader :organization_id

      # @return [Integer, nil]
      attr_reader :version

      def initialize(query, version: nil, options: nil, pat: nil, organization_id: nil)
        super(query, options:)

        @version = version || Mihari.config.censys_version
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
        when 3
          v3_configured?
        else
          false
        end
      end

      private

      def client
        case version
        when 3
          v3_client
        else
          raise ValueError("Unsupported Censys version: #{version}")
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

      def v3_configured?
        pat? && organization_id?
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
