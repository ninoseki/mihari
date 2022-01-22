# frozen_string_literal: true

module Mihari
  module Structs
    module GreyNoise
      class Metadata < Dry::Struct
        attribute :country, Types::String
        attribute :country_code, Types::String
        attribute :asn, Types::String

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
