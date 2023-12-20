# frozen_string_literal: true

module Mihari
  module Models
    #
    # Tag model
    #
    class Tag < ActiveRecord::Base
      has_many :taggings, dependent: :destroy

      include SearchCop

      search_scope :search do
        attributes :name
      end

      class << self
        include Searchable

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
