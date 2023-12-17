# frozen_string_literal: true

module Mihari
  module Structs
    module Filters
      class Search < Dry::Struct
        # @!attribute [r] q
        #   @return [String]
        attribute :q, Types::String

        # @!attribute [r] page
        #   @return [Integer, nil]
        attribute? :page, Types::Int.default(1)

        # @!attribute [r] limit
        #   @return [Integer, nil]
        attribute? :limit, Types::Int.default(10)
      end
    end
  end
end
