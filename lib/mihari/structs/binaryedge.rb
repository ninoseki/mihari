module Mihari
  module Structs
    module BinaryEdge
      class Target < Dry::Struct
        attribute :ip, Types::String

        #
        # @return [String]
        #
        def ip
          attributes[:ip]
        end

        class << self
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              ip: d.fetch("ip")
            )
          end
        end
      end

      class Event < Dry::Struct
        attribute :target, Target

        #
        # @return [Target]
        #
        def target
          attributes[:target]
        end

        class << self
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              target: Target.from_dynamic!(d.fetch("target"))
            )
          end
        end
      end

      class Response < Dry::Struct
        # @!attribute [r] page
        # @return [Integer]
        attribute :page,     Types::Integer

        # @!attribute [r] pagesize
        # @return [Integer]
        attribute :pagesize, Types::Integer

        # @!attribute [r] total
        # @return [Integer]
        attribute :total,    Types::Integer

        # @!attribute [r] events
        # @return [Array<Event>]
        attribute :events,   Types.Array(Event)

        #
        # @return [Array<Event>]
        #
        def events
          attributes[:events]
        end

        #
        # @return [Array<Artifact>]
        #
        def artifacts
          events.map { |event| Artifact.new(data: event.target.ip) }
        end

        class << self
          def from_dynamic!(d)
            d = Types::Hash[d]
            new(
              page: d.fetch("page"),
              pagesize: d.fetch("pagesize"),
              total: d.fetch("total"),
              events: d.fetch("events").map { |x| Event.from_dynamic!(x) }
            )
          end
        end
      end
    end
  end
end
