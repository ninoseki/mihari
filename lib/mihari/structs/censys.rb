# frozen_string_literal: true

require "json"
require "dry/struct"

module Mihari
  module Structs
    module Censys
      class AutonomousSystem < Dry::Struct
        attribute :asn, Types::Int

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

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            country: d["country"],
            country_code: d["country_code"]
          )
        end
      end

      class Hit < Dry::Struct
        attribute :ip, Types::String
        attribute :location, Location
        attribute :autonomous_system, AutonomousSystem

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            ip: d.fetch("ip"),
            location: Location.from_dynamic!(d.fetch("location")),
            autonomous_system: AutonomousSystem.from_dynamic!(d.fetch("autonomous_system"))
          )
        end
      end

      class Links < Dry::Struct
        attribute :next, Types::String
        attribute :prev, Types::String

        def self.from_dynamic!(d)
          d = Types::Hash[d]
          new(
            next: d.fetch("next"),
            prev: d.fetch("prev")
          )
        end
      end

      class Result < Dry::Struct
        attribute :query, Types::String
        attribute :total, Types::Int
        attribute :hits, Types.Array(Hit)
        attribute :links, Links

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
