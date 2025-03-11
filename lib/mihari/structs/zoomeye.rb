# frozen_string_literal: true

module Mihari
  module Structs
    module ZoomEye
      class Datanum < Dry::Struct
        # @!attribute [r] ip
        #   @return [String]
        attribute :ip, Types::String.optional

        # @!attribute [r] domain
        #   @return [String, nil]
        attribute :domain, Types::String.optional

        # @!attribute [r] url
        #   @return [String]
        attribute :url, Types::String.optional

        # @!attribute [r] metadata
        #   @return [Hash]
        attribute :metadata, Types::Hash

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              domain: d["domain"],
              ip: d["ip"],
              url: d["url"],
              metadata: d
            )
          end
        end

        def artifacts
          values = [url, domain, ip].compact
          values.map { |value| Mihari::Models::Artifact.new(data: value, metadata:) }
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] data
        #   @return [Array<Datanum>]
        attribute :data, Types.Array(Datanum)

        # @!attribute [r] total
        #   @return [Integer]
        attribute :total, Types::Int

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          data.map(&:artifacts).flatten
        end

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              data: d.fetch("data").map { |x| Datanum.from_dynamic!(x) },
              total: d.fetch("total")
            )
          end
        end
      end
    end
  end
end
