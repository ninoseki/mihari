# frozen_string_literal: true

module Mihari
  module Structs
    module Fofa
      class Response < Dry::Struct
        # @!attribute [r] error
        #   @return [Boolean]
        attribute :error, Types::Bool

        # @!attribute [r] errmsg
        #   @return [String, nil]
        attribute? :errmsg, Types::String.optional

        # @!attribute [r] size
        #   @return [Integer, nil]
        attribute? :size, Types::Int.optional

        # @!attribute [r] page
        #   @return [Integer, nil]
        attribute? :page, Types::Int.optional

        # @!attribute [r] mode
        #   @return [String, nil]
        attribute? :mode, Types::String.optional

        # @!attribute [r] query
        #   @return [String, nil]
        attribute? :query, Types::String.optional

        # @!attribute [r] results
        #   @return [Array<String>, nil]
        attribute? :results, Types.Array(Types.Array(Types::String)).optional

        class << self
          #
          # @param [Hash] d
          #
          def from_dynamic!(d)
            new(
              error: d.fetch("error"),
              errmsg: d["errmsg"],
              size: d["size"],
              page: d["page"],
              mode: d["mode"],
              query: d["query"],
              results: d["results"]
            )
          end
        end
      end
    end
  end
end
