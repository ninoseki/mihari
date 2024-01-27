# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # Google Public DNS enricher
    #
    class GooglePublicDNS < Base
      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Mihari::Models::Artifact]
      #
      def call(artifact)
        return if artifact.domain.nil?

        res = client.query_all(artifact.domain)

        artifact.tap do |tapped|
          if tapped.dns_records.empty?
            tapped.dns_records = res.answers.map do |answer|
              Models::DnsRecord.new(resource: answer.resource_type, value: answer.data)
            end
          end
        end
      end

      class << self
        #
        # @return [String]
        #
        def key
          "google_public_dns"
        end
      end

      private

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Boolean]
      #
      def callable_relationships?(artifact)
        artifact.dns_records.empty?
      end

      def supported_data_types
        %w[url domain]
      end

      def client
        @client ||= Clients::GooglePublicDNS.new(timeout:)
      end
    end
  end
end
