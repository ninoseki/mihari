# frozen_string_literal: true

module Mihari
  module Structs
    module BinaryEdge
      class Target < Dry::Struct
        # @!attribute [r] ip
        #   @return [String]
        attribute :ip, Types::String

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
        # @!attribute [r] target
        #   @return [Target]
        attribute :target, Target

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
        #   @return [Integer]
        attribute :page, Types::Int

        # @!attribute [r] pagesize
        #   @return [Integer]
        attribute :pagesize, Types::Int

        # @!attribute [r] total
        #   @return [Integer]
        attribute :total, Types::Int

        # @!attribute [r] events
        #   @return [Array<Event>]
        attribute :events, Types.Array(Event)

        #
        # @return [Array<Artifact>]
        #
        def artifacts
          events.map { |event| Models::Artifact.new(data: event.target.ip) }
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
