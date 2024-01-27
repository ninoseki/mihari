# frozen_string_literal: true

module Mihari
  module Structs
    module GooglePublicDNS
      INT_TYPE_TO_TYPE =
        {1 => :A, 38 => :A6, 28 => :AAAA, 18 => :AFSDB, 255 => :ANY, 42 => :APL, 34 => :ATMA, 252 => :AXFR, 37 => :CERT,
         5 => :CNAME, 49 => :DHCID, 32_769 => :DLV, 39 => :DNAME, 48 => :DNSKEY, 43 => :DS, 31 => :EID, 102 => :GID, 27 => :GPOS, 13 => :HINFO, 45 => :IPSECKEY, 20 => :ISDN, 251 => :IXFR, 25 => :KEY, 36 => :KX, 29 => :LOC, 254 => :MAILA, 253 => :MAILB, 7 => :MB, 3 => :MD, 4 => :MF, 8 => :MG, 14 => :MINFO, 9 => :MR, 15 => :MX, 35 => :NAPTR, 32 => :NIMLOC, 2 => :NS, 22 => :NSAP, 23 => :NSAP_PTR, 47 => :NSEC, 50 => :NSEC3, 51 => :NSEC3PARAMS, 10 => :NULL, 30 => :NXT, 41 => :OPT, 12 => :PTR, 26 => :PX, 17 => :RP, 46 => :RRSIG, 21 => :RT, 24 => :SIG, 40 => :SINK, 6 => :SOA, 33 => :SRV, 44 => :SSHFP, 250 => :TSIG, 16 => :TXT, 101 => :UID, 100 => :UINFO, 103 => :UNSPEC, 11 => :WKS, 19 => :X25}.freeze

      class Answer < Dry::Struct
        # @!attribute [r] name
        #   @return [String]
        attribute :name, Types::String

        # @!attribute [r] data
        #   @return [String]
        attribute :data, Types::String

        # @!attribute [r] resource_type
        #   @return [String]
        attribute :resource_type, Types::String

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            resource_type = INT_TYPE_TO_TYPE[d.fetch("type")].to_s
            new(
              name: d.fetch("name"),
              data: d.fetch("data"),
              resource_type:
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] answers
        #   @return [Array<Answer>]
        attribute :answers, Types.Array(Answer)

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              answers: d.fetch("Answer", []).map { |x| Answer.from_dynamic!(x) }
            )
          end
        end
      end
    end
  end
end
