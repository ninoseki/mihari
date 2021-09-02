require "json"
require "dry/struct"

module Mihari
  module Structs
    module IPInfo
      class Response < Dry::Struct
        attribute :ip, Types::String
        attribute :hostname, Types::String.optional
        attribute :loc, Types::String
        attribute :country_code, Types::String
        attribute :asn, Types::Integer

        class << self
          include Mixins::AutonomousSystem

          def from_dynamic!(d)
            d = Types::Hash[d]

            org = d.fetch("org")
            asn = org.split.first
            asn = normalize_asn(asn)

            new(
              ip: d.fetch("ip"),
              loc: d.fetch("loc"),
              hostname: d["hostname"],
              country_code: d.fetch("country"),
              asn: asn
            )
          end
      end
      end
    end
  end
end
