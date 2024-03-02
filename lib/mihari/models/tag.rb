# frozen_string_literal: true

module Mihari
  module Models
    #
    # Tag model
    #
    class Tag < ActiveRecord::Base
      # @!attribute [rw] name
      #   @return [String]

      has_many :taggings, dependent: :destroy

      include SearchCop
      include Concerns::Searchable

      search_scope :search do
        attributes :id, :name
      end

      class << self
        # @!method search_by_filter(filter)
        #   @param [Mihari::Structs::Filters::Search] filter
        #   @return [Array<Mihari::Models::Tag>]

        # @!method count_by_filter(filter)
        #   @param [Mihari::Structs::Filters::Search] filter
        #   @return [Integer]
      end
    end
  end
end
