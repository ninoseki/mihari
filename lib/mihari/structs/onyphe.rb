# frozen_string_literal: true

module Mihari
  module Structs
    module Onyphe
      class Result < Dry::Struct
        include Concerns::AutonomousSystemNormalizable

        # @!attribute [r] asn
        #   @return [String]
        attribute :asn, Types::String

        # @!attribute [r] country_code
        #   @return [String, nll]
        attribute :country_code, Types::String.optional

        # @!attribute [r] ip
        #   @return [String]

        attribute :ip, Types::String

        # @!attribute [r] metadata
        #   @return [Hash]
        attribute :metadata, Types::Hash

        #
        # @return [Mihari::Models::Artifact]
        #
        def artifact
          Mihari::Models::Artifact.new(
            data: ip,
            metadata: metadata,
            autonomous_system: as,
            geolocation: geolocation
          )
        end

        #
        # @return [Mihari::Geolocation, nil]
        #
        def geolocation
          return nil if country_code.nil?

          Mihari::Models::Geolocation.new(
            country: NormalizeCountry(country_code, to: :short),
            country_code: country_code
          )
        end

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
            d = Types::Hash[d]
            new(
              asn: d.fetch("asn"),
              ip: d.fetch("ip"),
              # Onyphe's country = 2-letter country code
              country_code: d["country"],
              metadata: d
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] count
        #   @return [Integer]
        attribute :count, Types::Int

        # @!attribute [r] error
        #   @return [Integer]
        attribute :error, Types::Int

        # @!attribute [r] max_page
        #   @return [Integer]
        attribute :max_page, Types::Int

        # @!attribute [r] page
        #   @return [Integer]
        attribute :page, Types::Int

        # @!attribute [r] results
        #   @return [Array<Result>]
        attribute :results, Types.Array(Result)

        # @!attribute [r] status
        #   @return [String]
        attribute :status, Types::String

        # @!attribute [r] total
        #   @return [Integer]
        attribute :total, Types::Int

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          results.map(&:artifact)
        end

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              count: d.fetch("count"),
              error: d.fetch("error"),
              max_page: d.fetch("max_page"),
              page: d.fetch("page").to_i,
              results: d.fetch("results").map { |x| Result.from_dynamic!(x) },
              status: d.fetch("status"),
              total: d.fetch("total")
            )
          end
        end
      end
    end
  end
end
