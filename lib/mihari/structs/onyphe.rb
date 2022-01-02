# frozen_string_literal: true

require "json"
require "dry/struct"

module Mihari
  module Structs
    module Onyphe
      class Result < Dry::Struct
        attribute :asn, Types::String
        attribute :country_code, Types::String.optional
        attribute :ip, Types::String

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            asn: d.fetch("asn"),
            ip: d.fetch("ip"),
            # Onyphe's country = 2-letter country code
            country_code: d["country"]
          )
        end
      end

      class Response < Dry::Struct
        attribute :count, Types::Int
        attribute :error, Types::Int
        attribute :max_page, Types::Int
        attribute :page, Types::String
        attribute :results, Types.Array(Result)
        attribute :status, Types::String
        attribute :total, Types::Int

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            count: d.fetch("count"),
            error: d.fetch("error"),
            max_page: d.fetch("max_page"),
            page: d.fetch("page"),
            results: d.fetch("results").map { |x| Result.from_dynamic!(x) },
            status: d.fetch("status"),
            total: d.fetch("total")
          )
        end
      end
    end
  end
end
