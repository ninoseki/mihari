# frozen_string_literal: true

module Mihari
  module Structs
    module Shodan
      class Location < Dry::Struct
        attribute :country_code, Types::String.optional
        attribute :country_name, Types::String.optional

        #
        # @return [String, nil]
        #
        def country_code
          attributes[:country_code]
        end

        #
        # @return [String, nil]
        #
        def country_name
          attributes[:country_name]
        end

        #
        # @return [Mihari::Geolocation, nil]
        #
        def to_geolocation
          return nil if country_name.nil? && country_code.nil?

          Mihari::Geolocation.new(
            country: country_name,
            country_code: country_code
          )
        end

        #
        # @param [Hash] d
        #
        # @return [Location]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            country_code: d["country_code"],
            country_name: d["country_name"]
          )
        end
      end

      class Match < Dry::Struct
        include Mixins::AutonomousSystem

        attribute :asn, Types::String.optional
        attribute :hostnames, Types.Array(Types::String)
        attribute :location, Location
        attribute :domains, Types.Array(Types::String)
        attribute :ip_str, Types::String
        attribute :port, Types::Integer
        attribute :metadata, Types::Hash

        #
        # @return [String, nil]
        #
        def asn
          attributes[:asn]
        end

        #
        # @return [Array<String>]
        #
        def hostnames
          attributes[:hostnames]
        end

        #
        # @return [Location]
        #
        def location
          attributes[:location]
        end

        #
        # @return [String]
        #
        def ip_str
          attributes[:ip_str]
        end

        #
        # @return [Integer]
        #
        def port
          attributes[:port]
        end

        #
        # @return [Hash]
        #
        def metadata
          attributes[:metadata]
        end

        #
        # @return [Mihari::AutonomousSystem, nil]
        #
        def to_asn
          return nil if asn.nil?

          Mihari::AutonomousSystem.new(asn: normalize_asn(asn))
        end

        #
        # @param [Hash] d
        #
        # @return [Match]
        #
        def self.from_dynamic!(d)
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

      class Result < Dry::Struct
        attribute :matches, Types.Array(Match)
        attribute :total, Types::Int

        #
        # @return [Array<Match>]
        #
        def matches
          attributes[:matches]
        end

        #
        # @return [Integer]
        #
        def total
          attributes[:total]
        end

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
        # @return [Array<Mihari::Artifact>]
        #
        def to_artifacts
          matches.map do |match|
            metadata = collect_metadata_by_ip(match.ip_str)
            ports = collect_ports_by_ip(match.ip_str).map do |port|
              Mihari::Port.new(port: port)
            end
            reverse_dns_names = collect_hostnames_by_ip(match.ip_str).map do |name|
              Mihari::ReverseDnsName.new(name: name)
            end

            Mihari::Artifact.new(
              data: match.ip_str,
              metadata: metadata,
              autonomous_system: match.to_asn,
              geolocation: match.location.to_geolocation,
              ports: ports,
              reverse_dns_names: reverse_dns_names
            )
          end
        end

        #
        # @param [Hash] d
        #
        # @return [Result]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            matches: d.fetch("matches", []).map { |x| Match.from_dynamic!(x) },
            total: d.fetch("total")
          )
        end
      end

      class InternetDBResponse < Dry::Struct
        attribute :ip, Types::String
        attribute :ports, Types.Array(Types::Int)
        attribute :cpes, Types.Array(Types::String)
        attribute :hostnames, Types.Array(Types::String)
        attribute :tags, Types.Array(Types::String)
        attribute :vulns, Types.Array(Types::String)

        #
        # @return [String]
        #
        def ip
          attributes[:ip]
        end

        #
        # @return [Array<Integer>]
        #
        def ports
          attributes[:ports]
        end

        #
        # @return [Array<String>]
        #
        def cpes
          attributes[:cpes]
        end

        #
        # @return [Array<String>]
        #
        def hostnames
          attributes[:hostnames]
        end

        #
        # @return [Array<String>]
        #
        def tags
          attributes[:tags]
        end

        #
        # @return [Array<String>]
        #
        def vulns
          attributes[:vulns]
        end

        #
        # @param [Hash] d
        #
        # @return [InternetDBResponse]
        #
        def self.from_dynamic!(d)
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
        def self.from_json!(json)
          from_dynamic!(JSON.parse(json))
        end
      end
    end
  end
end
