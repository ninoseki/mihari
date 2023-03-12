# frozen_string_literal: true

module Mihari
  module Structs
    module Onyphe
      class Result < Dry::Struct
        include Mixins::AutonomousSystem

        attribute :asn, Types::String
        attribute :country_code, Types::String.optional
        attribute :ip, Types::String
        attribute :metadata, Types::Hash

        #
        # @param [String] source
        #
        # @return [Mihari::Artifact]
        #
        def to_artifact(source = "Onyphe")
          Mihari::Artifact.new(
            data: ip,
            source: source,
            metadata: metadata,
            autonomous_system: to_as,
            geolocation: to_geolocation
          )
        end

        #
        # @return [Mihari::Geolocation, nil]
        #
        def to_geolocation
          return nil if country_code.nil?

          Mihari::Geolocation.new(
            country: NormalizeCountry(country_code, to: :short),
            country_code: country_code
          )
        end

        #
        # @return [Mihari::AutonomousSystem]
        #
        def to_as
          Mihari::AutonomousSystem.new(asn: normalize_asn(asn))
        end

        def self.from_dynamic!(d)
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

      class Response < Dry::Struct
        attribute :count, Types::Int
        attribute :error, Types::Int
        attribute :max_page, Types::Int
        attribute :page, Types::Int
        attribute :results, Types.Array(Result)
        attribute :status, Types::String
        attribute :total, Types::Int

        #
        # @param [String] source
        #
        # @return [Array<Mihari::Artifact>]
        #
        def to_artifacts(source = "Onyphe")
          results.map { |result| result.to_artifact(source) }
        end

        def self.from_dynamic!(d)
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
