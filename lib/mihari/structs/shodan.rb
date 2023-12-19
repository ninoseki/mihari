# frozen_string_literal: true

module Mihari
  module Structs
    module Shodan
      class Location < Dry::Struct
        # @!attribute [r] country_code
        #   @return [String, nil]
        attribute :country_code, Types::String.optional

        # @!attribute [r] country_name
        #   @return [String, nil]
        attribute :country_name, Types::String.optional

        #
        # @return [Mihari::Geolocation, nil]
        #
        def geolocation
          return nil if country_name.nil? || country_code.nil?

          Mihari::Models::Geolocation.new(
            country: country_name,
            country_code: country_code
          )
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Location]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              country_code: d["country_code"],
              country_name: d["country_name"]
            )
          end
        end
      end

      class Match < Dry::Struct
        include Mixins::AutonomousSystem

        # @!attribute [r] asn
        #   @return [String, nil]
        attribute :asn, Types::String.optional

        # @!attribute [r] hostname
        #   @return [Array<String>]
        attribute :hostnames, Types.Array(Types::String)

        # @!attribute [r] location
        #   @return [Location]
        attribute :location, Location

        # @!attribute [r] domains
        #   @return [Array<String>]
        attribute :domains, Types.Array(Types::String)

        # @!attribute [r] ip_str
        #   @return [String]
        attribute :ip_str, Types::String

        # @!attribute [r] port
        #   @return [Integer]
        attribute :port, Types::Int

        # @!attribute [r] metadata
        #   @return [Hash]
        attribute :metadata, Types::Hash

        #
        # @return [Mihari::AutonomousSystem, nil]
        #
        def _asn
          return nil if asn.nil?

          Mihari::Models::AutonomousSystem.new(asn: normalize_asn(asn))
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Match]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]

            # hostnames should be an array of string but sometimes Shodan returns a string
            # e.g. "hostnames": "set(['149.28.146.131.vultr.com', 'rebs.ga'])",
            # https://github.com/ninoseki/mihari/issues/424
            # so use an empty array if hostnames is a string
            hostnames = d.fetch("hostnames")
            hostnames = [] if hostnames.is_a?(String)

            new(
              asn: d["asn"],
              hostnames: hostnames,
              location: Location.from_dynamic!(d.fetch("location")),
              domains: d.fetch("domains"),
              ip_str: d.fetch("ip_str"),
              port: d.fetch("port"),
              metadata: d
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] matches
        #   @return [Array<Match>]
        attribute :matches, Types.Array(Match)

        # @!attribute [r] total
        #   @return [Integer]
        attribute :total, Types::Int

        #
        # Collect metadata from matches
        #
        # @param [String] ip
        #
        # @return [Array<Hash>]
        #
        def collect_metadata_by_ip(ip)
          matches.select { |match| match.ip_str == ip }.map(&:metadata)
        end

        #
        # Collect ports from matches
        #
        # @param [String] ip
        #
        # @return [Array<String>]
        #
        def collect_ports_by_ip(ip)
          matches.select { |match| match.ip_str == ip }.map(&:port)
        end

        #
        # Collect hostnames from matches
        #
        # @param [String] ip
        #
        # @return [Array<String>]
        #
        def collect_hostnames_by_ip(ip)
          matches.select { |match| match.ip_str == ip }.map(&:hostnames).flatten.uniq
        end

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          matches.map do |match|
            metadata = collect_metadata_by_ip(match.ip_str)

            ports = collect_ports_by_ip(match.ip_str).map do |port|
              Mihari::Models::Port.new(port: port)
            end
            reverse_dns_names = collect_hostnames_by_ip(match.ip_str).map do |name|
              Mihari::Models::ReverseDnsName.new(name: name)
            end

            Mihari::Models::Artifact.new(
              data: match.ip_str,
              metadata: metadata,
              autonomous_system: match._asn,
              geolocation: match.location.geolocation,
              ports: ports,
              reverse_dns_names: reverse_dns_names
            )
          end
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Result]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              matches: d.fetch("matches", []).map { |x| Match.from_dynamic!(x) },
              total: d.fetch("total")
            )
          end
        end
      end

      class InternetDBResponse < Dry::Struct
        # @!attribute [r] ip
        #   @return [String]
        attribute :ip, Types::String

        # @!attribute [r] ports
        #   @return [Array<Integer>]
        attribute :ports, Types.Array(Types::Int)

        # @!attribute [r] cpes
        #   @return [Array<String>]
        attribute :cpes, Types.Array(Types::String)

        # @!attribute [r] hostnames
        #   @return [Array<String>]
        attribute :hostnames, Types.Array(Types::String)

        # @!attribute [r] tags
        #   @return [Array<String>]
        attribute :tags, Types.Array(Types::String)

        # @!attribute [r] vulns
        #   @return [Array<String>]
        attribute :vulns, Types.Array(Types::String)

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              ip: d.fetch("ip"),
              ports: d.fetch("ports"),
              cpes: d.fetch("cpes"),
              hostnames: d.fetch("hostnames"),
              tags: d.fetch("tags"),
              vulns: d.fetch("vulns")
            )
          end

          #
          # @param [String] json
          #
          # @return [InternetDBResponse]
          #
          def from_json!(json)
            from_dynamic!(JSON.parse(json))
          end
        end
      end
    end
  end
end
