# frozen_string_literal: true

module Mihari
  module Services
    #
    # Rule builder
    #
    class RuleBuilder < Service
      #
      # @param [String] path_or_id
      #
      # @return [Mihari::Rule]
      #
      def call(path_or_id)
        res = Try { Rule.from_model Mihari::Models::Rule.find(path_or_id) }
        return res.value! if res.value?

        raise ArgumentError, "#{path_or_id} not found" unless Pathname(path_or_id).exist?

        Rule.from_yaml ERB.new(File.read(path_or_id)).result
      end
    end

    #
    # Autonomous system builder
    #
    class AutonomousSystemBuilder < Service
      #
      # @param [String] ip
      # @param [Mihari::Enrichers::MMDB] enricher
      #
      # @return [Mihari::Models::AutonomousSystem, nil]
      #
      def call(ip, enricher: Enrichers::MMDB.new)
        enricher.result(ip).fmap do |res|
          Models::AutonomousSystem.new(number: res.asn) if res.asn
        end.value_or nil
      end
    end

    #
    # CPE builder
    #
    class CPEBuilder < Service
      #
      # Build CPEs
      #
      # @param [String] ip
      # @param [Mihari::Enrichers::Shodan] enricher
      #
      # @return [Array<Mihari::Models::CPE>]
      #
      def call(ip, enricher: Enrichers::Shodan.new)
        enricher.result(ip).fmap do |res|
          (res&.cpes || []).map { |cpe| Models::CPE.new(name: cpe) }
        end.value_or []
      end
    end

    #
    # DNS record builder
    #
    class DnsRecordBuilder < Service
      #
      # Build DNS records
      #
      # @param [String] domain
      # @param [Mihari::Enrichers::Shodan] enricher
      #
      # @return [Array<Mihari::Models::DnsRecord>]
      #
      def call(domain, enricher: Enrichers::GooglePublicDNS.new)
        enricher.result(domain).fmap do |res|
          res.answers.map { |answer| Models::DnsRecord.new(resource: answer.resource_type, value: answer.data) }
        end.value_or []
      end
    end

    #
    # Geolocation builder
    #
    class GeolocationBuilder < Service
      #
      # Build Geolocation
      #
      # @param [String] ip
      # @param [Mihari::Enrichers::MMDB] enricher
      #
      # @return [Mihari::Models::Geolocation, nil]
      #
      def call(ip, enricher: Enrichers::MMDB.new)
        enricher.result(ip).fmap do |res|
          if res.country_code
            Models::Geolocation.new(
              country: NormalizeCountry(res.country_code, to: :short),
              country_code: res.country_code
            )
          end
        end.value_or nil
      end
    end

    #
    # Port builder
    #
    class PortBuilder < Service
      #
      # Build ports
      #
      # @param [String] ip
      # @param [Mihari::Enrichers::Shodan] enricher
      #
      # @return [Array<Mihari::Models::Port>]
      #
      def call(ip, enricher: Enrichers::Shodan.new)
        enricher.result(ip).fmap do |res|
          (res&.ports || []).map { |port| Models::Port.new(number: port) }
        end.value_or []
      end
    end

    #
    # Reverse DNS name builder
    #
    class ReverseDnsNameBuilder < Service
      #
      # Build reverse DNS names
      #
      # @param [String] ip
      # @param [Mihari::Enrichers::Shodan] enricher
      #
      # @return [Array<Mihari::Models::ReverseDnsName>]
      #
      def call(ip, enricher: Enrichers::Shodan.new)
        enricher.result(ip).fmap do |res|
          (res&.hostnames || []).map { |name| Models::ReverseDnsName.new(name: name) }
        end.value_or []
      end
    end

    #
    # Vulnerability builder
    #
    class VulnerabilityBuilder < Service
      #
      # Build vulnerabilities
      #
      # @param [String] ip
      # @param [Mihari::Enrichers::Shodan] enricher
      #
      # @return [Array<Mihari::Models::Vulnerability>]
      #
      def call(ip, enricher: Enrichers::Shodan.new)
        enricher.result(ip).fmap do |res|
          (res&.vulns || []).map { |name| Models::Vulnerability.new(name: name) }
        end.value_or []
      end
    end

    #
    # Whois record builder
    #
    class WhoisRecordBuilder < Service
      #
      # Build whois record
      #
      # @param [String] domain
      # @param [Mihari::Enrichers::Whois] enricher
      #
      # @return [Mihari::Models::WhoisRecord, nil]
      #
      def call(domain, enricher: Enrichers::Whois.new)
        enricher.result(domain).value_or nil
      end
    end
  end
end
