# frozen_string_literal: true

module Mihari
  module Structs
    module HunterHow
      class ListItem < Dry::Struct
        # @!attribute [r] domain
        #   @return [String]
        attribute :domain, Types::String

        # @!attribute [r] ip
        #   @return [String]
        attribute :ip, Types::String

        # @!attribute [r] port
        #   @return [Integer]
        attribute :port, Types::Int

        #
        # @return [Mihari::Models::Artifact]
        #
        def artifact
          Models::Artifact.new(data: ip)
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [ListItem]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              domain: d.fetch("domain"),
              ip: d.fetch("ip"),
              port: d.fetch("port")
            )
          end
        end
      end

      class DataClass < Dry::Struct
        # @!attribute [r] list
        #   @return [Array<ListItem>]
        attribute :list, Types.Array(ListItem)

        # @!attribute [r] total
        #   @return [Integer]
        attribute :total, Types::Int

        #
        # @return [Array<Mihari::Models::Artifact>]
        #
        def artifacts
          list.map(&:artifact)
        end

        class << self
          #
          # @param [Hash] d
          #
          # @return [DataClass]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              list: d.fetch("list").map { |x| ListItem.from_dynamic!(x) },
              total: d.fetch("total")
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] code
        #   @return [Integer]
        attribute :code, Types::Int

        # @!attribute [r] data
        #   @return [DataClass]
        attribute :data, DataClass

        # @!attribute [r] message
        #   @return [String]
        attribute :message, Types::String

        class << self
          #
          # @param [Hash] d
          #
          # @return [Response]
          #
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              code: d.fetch("code"),
              data: DataClass.from_dynamic!(d.fetch("data")),
              message: d.fetch("message")
            )
          end
        end
      end
    end
  end
end
