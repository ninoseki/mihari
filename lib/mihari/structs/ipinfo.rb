# frozen_string_literal: true

module Mihari
  module Structs
    module IPInfo
      class Response < Dry::Struct
        # @!attribute [r] ip
        #   @return [String]
        attribute :ip, Types::String

        # @!attribute [r] hostname
        #   @return [String, nil]
        attribute :hostname, Types::String.optional

        # @!attribute [r] loc
        #   @return [String, nil]
        attribute :loc, Types::String.optional

        # @!attribute [r] country_code
        #   @return [String, nil]
        attribute :country_code, Types::String.optional

        # @!attribute [r] asn
        #   @return [Integer, nil]
        attribute :asn, Types::Int.optional

        class << self
          include Mixins::AutonomousSystem

          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = d.deep_stringify_keys
            d = Types::Hash[d]

            asn = nil
            asn_ = d.dig("asn", "asn")
            asn = normalize_asn(asn_) unless asn_.nil?

            new(
              ip: d.fetch("ip"),
              loc: d["loc"],
              hostname: d["hostname"],
              country_code: d["country"],
              asn: asn
            )
          end
        end
      end
    end
  end
end
