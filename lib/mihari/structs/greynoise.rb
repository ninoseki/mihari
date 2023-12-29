# frozen_string_literal: true

module Mihari
  module Structs
    module GreyNoise
      class Metadata < Dry::Struct
        include Concerns::AutonomousSystemNormalizable

        # @!attribute [r] country
        #   @return [String]
        attribute :country, Types::String

        # @!attribute [r] country_code
        #   @return [String]
        attribute :country_code, Types::String

        # @!attribute [r] asn
        #   @return [String]
        attribute :asn, Types::String

        #
        # @return [Mihari::AutonomousSystem]
        #
        def as
          Mihari::Models::AutonomousSystem.new(asn: normalize_asn(asn))
        end

        #
        # @return [Mihari::Geolocation]
        #
        def geolocation
          Mihari::Models::Geolocation.new(
            country: country,
            country_code: country_code
          )
        end

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              country: d.fetch("country"),
              country_code: d.fetch("country_code"),
              asn: d.fetch("asn")
            )
          end
        end
      end

      class Datum < Dry::Struct
        # @!attribute [r] ip
        #   @return [String]
        attribute :ip, Types::String

        # @!attribute [r] metadata
        #   @return [Metadata]
        attribute :metadata, Metadata

        # @!attribute [r] metadata_
        #   @return [Hash]
        attribute :metadata_, Types::Hash

        #
        # @return [Mihari::Models::Artifact]
        #
        def artifact
          Mihari::Models::Artifact.new(
            data: ip,
            metadata: metadata_,
            autonomous_system: metadata.as,
            geolocation: metadata.geolocation
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
              metadata: Metadata.from_dynamic!(d.fetch("metadata")),
              metadata_: d
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] complete
        #   @return [Boolean]
        attribute :complete, Types::Bool

        # @!attribute [r] count
        #   @return [Integer]
        attribute :count, Types::Int

        # @!attribute [r] data
        #   @return [Array<Datnum>]
        attribute :data, Types.Array(Datum)

        # @!attribute [r] message
        #   @return [String]
        attribute :message, Types::String

        # @!attribute [r] query
        #   @return [String]
        attribute :query, Types::String

        # @!attribute [r] scroll
        #   @return [String, nil]
        attribute :scroll, Types::String.optional

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          data.map(&:artifact)
        end

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              complete: d.fetch("complete"),
              count: d.fetch("count"),
              data: d.fetch("data").map { |x| Datum.from_dynamic!(x) },
              message: d.fetch("message"),
              query: d.fetch("query"),
              scroll: d["scroll"]
            )
          end
        end
      end
    end
  end
end
