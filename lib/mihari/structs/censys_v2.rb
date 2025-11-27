# frozen_string_literal: true

module Mihari
  module Structs
    module CensysV2
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
