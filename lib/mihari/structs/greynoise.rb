# frozen_string_literal: true

module Mihari
  module Structs
    module GreyNoise
      class Metadata < Dry::Struct
        include Mixins::AutonomousSystem

        attribute :country, Types::String
        attribute :country_code, Types::String
        attribute :asn, Types::String

        #
        # @return [Mihari::AutonomousSystem]
        #
        def to_as
          Mihari::AutonomousSystem.new(asn: normalize_asn(asn))
        end

        #
        # @return [Mihari::Geolocation]
        #
        def to_geolocation
          Mihari::Geolocation.new(
            country: country,
            country_code: country_code
          )
        end

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            country: d.fetch("country"),
            country_code: d.fetch("country_code"),
            asn: d.fetch("asn")
          )
        end
      end

      class Datum < Dry::Struct
        attribute :ip, Types::String
        attribute :metadata, Metadata
        attribute :metadata_, Types::Hash

        #
        # @param [String] source
        #
        # @return [Mihari::Artifact]
        #
        def to_artifact(source = "GreyNoise")
          Mihari::Artifact.new(
            data: ip,
            source: source,
            metadata: metadata_,
            autonomous_system: metadata.to_as,
            geolocation: metadata.to_geolocation
          )
        end

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            ip: d.fetch("ip"),
            metadata: Metadata.from_dynamic!(d.fetch("metadata")),
            metadata_: d
          )
        end
      end

      class Response < Dry::Struct
        attribute :complete, Types::Bool
        attribute :count, Types::Int
        attribute :data, Types.Array(Datum)
        attribute :message, Types::String
        attribute :query, Types::String

        #
        # @param [String] source
        #
        # @return [Array<Mihari::Artifact>]
        #
        def to_artifacts(source = "GreyNoise")
          data.map { |datum| datum.to_artifact(source) }
        end

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            complete: d.fetch("complete"),
            count: d.fetch("count"),
            data: d.fetch("data").map { |x| Datum.from_dynamic!(x) },
            message: d.fetch("message"),
            query: d.fetch("query")
          )
        end
      end
    end
  end
end
