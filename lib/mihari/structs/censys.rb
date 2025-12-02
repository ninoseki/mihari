# frozen_string_literal: true

module Mihari
  module Structs
    module Censys
      module V2
        class AutonomousSystem < Dry::Struct
          include Concerns::AutonomousSystemNormalizable

          # @!attribute [r] asn
          #   @return [Integer]
          attribute :asn, Types::Int

          #
          # @return [Mihari::AutonomousSystem]
          #
          def as
            Mihari::Models::AutonomousSystem.new(number: normalize_asn(asn))
          end

          class << self
            #
            # @param [Hash] d
            #
            def from_dynamic!(d)
              return nil if d.nil?

              d = Types::Hash[d]
              new(
                asn: d.fetch("asn")
              )
            end
          end
        end

        class Location < Dry::Struct
          # @!attribute [r] country
          #   @return [String, nil]
          attribute :country, Types::String.optional

          # @!attribute [r] country_code
          #   @return [String, nil]
          attribute :country_code, Types::String.optional

          #
          # @return [Mihari::Geolocation] <description>
          #
          def geolocation
            # sometimes Censys overlooks country
            # then set geolocation as nil
            return nil if country.nil?

            Mihari::Models::Geolocation.new(
              country:,
              country_code:
            )
          end

          class << self
            #
            # @param [Hash] d
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
          # @!attribute [r] port
          #   @return [Integer, nil]
          attribute :port, Types::Int

          #
          # @return [Mihari::Port]
          #
          def _port
            Models::Port.new(number: port)
          end

          class << self
            #
            # @param [Hash] d
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
          # @!attribute [r] ip
          #   @return [String]
          attribute :ip, Types::String

          # @!attribute [r] location
          #   @return [Location]
          attribute :location, Location

          # @!attribute [r] autonomous_system
          #   @return [AutonomousSystem, nil]
          attribute :autonomous_system, AutonomousSystem.optional

          # @!attribute [r] metadata
          #   @return [Hash]
          attribute :metadata, Types::Hash

          # @!attribute [r] services
          #   @return [Array<Service>]
          attribute :services, Types.Array(Service)

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
              metadata:,
              autonomous_system: autonomous_system&.as,
              geolocation: location.geolocation,
              ports:
            )
          end

          class << self
            #
            # @param [Hash] d
            #
            def from_dynamic!(d)
              d = Types::Hash[d]
              new(
                ip: d.fetch("ip"),
                location: Location.from_dynamic!(d.fetch("location")),
                autonomous_system: AutonomousSystem.from_dynamic!(d["autonomous_system"]),
                metadata: d,
                services: d.fetch("services", []).map { |x| Service.from_dynamic!(x) }
              )
            end
          end
        end

        class Links < Dry::Struct
          # @!attribute [r] next
          #   @return [String, nil]
          attribute :next, Types::String.optional

          # @!attribute [r] prev
          #   @return [String, nil]
          attribute :prev, Types::String.optional

          class << self
            #
            # @param [Hash] d
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
          # @!attribute [r] query
          #   @return [String]
          attribute :query, Types::String

          # @!attribute [r] total
          #   @return [Integer]
          attribute :total, Types::Int

          # @!attribute [r] hits
          #   @return [Array<Hit>]
          attribute :hits, Types.Array(Hit)

          # @!attribute [r] links
          #   @return [Links]
          attribute :links, Links

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
          # @!attribute [r] code
          #   @return [Integer]
          attribute :code, Types::Int

          # @!attribute [r] status
          #   @return [String]
          attribute :status, Types::String

          # @!attribute [r] result
          #   @return [Result]
          attribute :result, Result

          def artifacts
            result.artifacts
          end

          class << self
            #
            # @param [Hash] d
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

      module V3
        class Hit < Dry::Struct
          include Mihari::Concerns::AutonomousSystemNormalizable

          attribute :ip, Types::String
          attribute :autonomous_system, Types::Hash.optional
          attribute :location, Types::Hash.optional
          attribute :services, Types.Array(Types::Hash).optional
          attribute :metadata, Types::Hash

          def ports
            (services || []).filter_map { |svc| svc["port"] }
          end

          def artifact
            Mihari::Models::Artifact.new(
              data: ip,
              metadata: metadata,
              autonomous_system: autonomous_system_model,
              geolocation: geolocation_model,
              ports: ports.map { |p| Mihari::Models::Port.new(number: p) }
            )
          end

          def autonomous_system_model
            return nil if autonomous_system.nil?

            Mihari::Models::AutonomousSystem.new(number: normalize_asn(autonomous_system["asn"]))
          end

          def geolocation_model
            return nil if location.nil?

            Mihari::Models::Geolocation.new(
              country: location["country"],
              country_code: location["country_code"]
            )
          end

          class << self
            def from_dynamic!(d)
              res = d.dig("host_v1", "resource") || {}
              new(
                ip: res["ip"],
                autonomous_system: res["autonomous_system"],
                location: res["location"],
                services: res["services"],
                metadata: d
              )
            end
          end
        end

        class Result < Dry::Struct
          attribute :hits, Types.Array(Hit)
          attribute :next_page_token, Types::String.optional

          def artifacts
            hits.map(&:artifact)
          end

          class << self
            def from_dynamic!(d)
              new(
                hits: (d["hits"] || []).map { |x| Hit.from_dynamic!(x) },
                next_page_token: d["next_page_token"]
              )
            end
          end
        end

        class Response < Dry::Struct
          attribute :result, Result

          def artifacts
            result.artifacts
          end

          class << self
            def from_dynamic!(d)
              new(
                result: Result.from_dynamic!(d["result"])
              )
            end
          end
        end
      end
    end
  end
end
