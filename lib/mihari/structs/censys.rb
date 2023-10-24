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
        def as
          Mihari::Models::AutonomousSystem.new(asn: normalize_asn(asn))
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [AutonomousSystem]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              asn: d.fetch("asn")
            )
          end
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
        def geolocation
          # sometimes Censys overlooks country
          # then set geolocation as nil
          return nil if country.nil?

          Mihari::Models::Geolocation.new(
            country: country,
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
              country: d["country"],
              country_code: d["country_code"]
            )
          end
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
        def _port
          Models::Port.new(port: port)
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Service]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              port: d.fetch("port")
            )
          end
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
        def ports
          services.map(&:_port)
        end

        #
        # @return [Mihari::Models::Artifact]
        #
        def artifact
          Models::Artifact.new(
            data: ip,
            metadata: metadata,
            autonomous_system: autonomous_system.as,
            geolocation: location.geolocation,
            ports: ports
          )
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [Hit]
          #
          def from_dynamic!(d)
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

        class << self
          #
          # @param [Hash] d
          #
          # @return [Links]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              next: d["next"],
              prev: d["prev"]
            )
          end
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
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          hits.map(&:artifact)
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
              query: d.fetch("query"),
              total: d.fetch("total"),
              hits: d.fetch("hits", []).map { |x| Hit.from_dynamic!(x) },
              links: Links.from_dynamic!(d.fetch("links"))
            )
          end
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

        class << self
          #
          # @param [Hash] d
          #
          # @return [Response]
          #
          def from_dynamic!(d)
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
end
