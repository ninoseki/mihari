module Mihari
  module Structs
    module HunterHow
      class ListItem < Dry::Struct
        attribute :domain, Types::String
        attribute :ip, Types::String
        attribute :port, Types::Integer

        #
        # @return [String]
        #
        def ip
          attributes[:ip]
        end

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
        attribute :list, Types.Array(ListItem)
        attribute :total, Types::Integer

        #
        # @return [Array<ListItem>]
        #
        def list
          attributes[:list]
        end

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
        attribute :code, Types::Integer
        attribute :data, DataClass
        attribute :message, Types::String

        #
        # @return [DataClass]
        #
        def data
          attributes[:data]
        end

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
