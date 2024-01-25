# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # Shodan enricher
    #
    class Shodan < Base
      #
      # Query Shodan Internet DB
      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Mihari::Structs::Shodan::InternetDBResponse, nil]
      #
      def call(artifact)
        res = client.query(artifact.data)

        artifact.tap do |tapped|
          tapped.cpes = (res&.cpes || []).map { |cpe| Models::CPE.new(name: cpe) } if tapped.cpes.empty?
          tapped.ports = (res&.ports || []).map { |port| Models::Port.new(number: port) } if tapped.ports.empty?

          if tapped.reverse_dns_names.empty?
            tapped.reverse_dns_names = (res&.hostnames || []).map do |name|
              Models::ReverseDnsName.new(name: name)
            end
          end

          if tapped.vulnerabilities.empty?
            tapped.vulnerabilities = (res&.vulns || []).map do |name|
              Models::Vulnerability.new(name: name)
            end
          end
        end
      end

      private

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Boolean]
      #
      def callable_relationships?(artifact)
        artifact.cpes.empty? || artifact.ports.empty? || artifact.reverse_dns_names.empty? || artifact.vulnerabilities.empty?
      end

      def supported_data_types
        %w[ip]
      end

      def client
        @client ||= Clients::ShodanInternetDB.new(timeout: timeout)
      end
    end
  end
end
