# frozen_string_literal: true

module Mihari
  module Structs
    module Censys
      class AutonomousSystem < Dry::Struct
        include Mixins::AutonomousSystem

        attribute :asn, Types::Int

        #
        # @return [Integer]
        #
        def asn
          attributes[:asn]
        end

        #
        # @return [Mihari::AutonomousSystem]
        #
        def to_as
          Mihari::AutonomousSystem.new(asn: normalize_asn(asn))
        end

        #
        # @param [Hash] d
        #
        # @return [AutonomousSystem]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            asn: d.fetch("asn")
          )
        end
      end

      class Location < Dry::Struct
        attribute :country, Types::String.optional
        attribute :country_code, Types::String.optional

        #
        # @return [String, nil]
        #
        def country
          attributes[:country]
        end

        #
        # @return [String, nil]
        #
        def country_code
          attributes[:country_code]
        end

        #
        # @return [Mihari::Geolocation] <description>
        #
        def to_geolocation
          # sometimes Censys overlooks country
          # then set geolocation as nil
          return nil if country.nil?

          Mihari::Geolocation.new(
            country: country,
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
            country: d["country"],
            country_code: d["country_code"]
          )
        end
      end

      class Service < Dry::Struct
        attribute :port, Types::Integer

        #
        # @return [Integer]
        #
        def port
          attributes[:port]
        end

        #
        # @return [Mihari::Port]
        #
        def to_port
          Port.new(port: port)
        end

        #
        # @param [Hash] d
        #
        # @return [Service]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            port: d.fetch("port")
          )
        end
      end

      class Hit < Dry::Struct
        attribute :ip, Types::String
        attribute :location, Location
        attribute :autonomous_system, AutonomousSystem
        attribute :metadata, Types::Hash
        attribute :services, Types.Array(Service)

        #
        # @return [String]
        #
        def ip
          attributes[:ip]
        end

        #
        # @return [Location]
        #
        def location
          attributes[:location]
        end

        #
        # @return [AutonomousSystem]
        #
        def autonomous_system
          attributes[:autonomous_system]
        end

        #
        # @return [Hash]
        #
        def metadata
          attributes[:metadata]
        end

        #
        # @return [Array<Service>]
        #
        def services
          attributes[:services]
        end

        #
        # @return [Array<Mihari::Port>]
        #
        def to_ports
          services.map(&:to_port)
        end

        #
        # @return [Mihari::Artifact]
        #
        def to_artifact
          Artifact.new(
            data: ip,
            metadata: metadata,
            autonomous_system: autonomous_system.to_as,
            geolocation: location.to_geolocation,
            ports: to_ports
          )
        end

        #
        # @param [Hash] d
        #
        # @return [Hit]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            ip: d.fetch("ip"),
            location: Location.from_dynamic!(d.fetch("location")),
            autonomous_system: AutonomousSystem.from_dynamic!(d.fetch("autonomous_system")),
            metadata: d,
            services: d.fetch("services", []).map { |x| Service.from_dynamic!(x) }
          )
        end
      end

      class Links < Dry::Struct
        attribute :next, Types::String.optional
        attribute :prev, Types::String.optional

        #
        # @return [String, nil]
        #
        def next
          attributes[:next]
        end

        #
        # @return [String, nil]
        #
        def prev
          attributes[:prev]
        end

        #
        # @param [Hash] d
        #
        # @return [Links]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            next: d["next"],
            prev: d["prev"]
          )
        end
      end

      class Result < Dry::Struct
        attribute :query, Types::String
        attribute :total, Types::Int
        attribute :hits, Types.Array(Hit)
        attribute :links, Links

        #
        # @return [String]
        #
        def query
          attributes[:query]
        end

        #
        # @return [Integer]
        #
        def total
          attributes[:total]
        end

        #
        # @return [Array<Hit>]
        #
        def hits
          attributes[:hits]
        end

        #
        # @return [Links]
        #
        def links
          attributes[:links]
        end

        #
        # @return [Array<Mihari::Artifact>]
        #
        def to_artifacts
          hits.map { |hit| hit.to_artifact }
        end

        #
        # @param [Hash] d
        #
        # @return [Result]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            query: d.fetch("query"),
            total: d.fetch("total"),
            hits: d.fetch("hits", []).map { |x| Hit.from_dynamic!(x) },
            links: Links.from_dynamic!(d.fetch("links"))
          )
        end
      end

      class Response < Dry::Struct
        attribute :code, Types::Int
        attribute :status, Types::String
        attribute :result, Result

        #
        # @return [Integer]
        #
        def code
          attributes[:code]
        end

        #
        # @return [String]
        #
        def status
          attributes[:status]
        end

        #
        # @return [Result]
        #
        def result
          attributes[:result]
        end

        #
        # @param [Hash] d
        #
        # @return [Response]
        #
        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            code: d.fetch("code"),
            status: d.fetch("status"),
            result: Result.from_dynamic!(d.fetch("result"))
          )
        end
      end
    end
  end
end
