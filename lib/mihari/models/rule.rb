# frozen_string_literal: true

module Mihari
  module Models
    #
    # Rule model
    #
    class Rule < ActiveRecord::Base
      has_many :alerts, dependent: :destroy
      has_many :taggings, dependent: :destroy
      has_many :tags, through: :taggings

      include SearchCop

      search_scope :search do
        attributes :id, :title, :description, :created_at, :updated_at
        attributes tag: "tags.name"
      end

      def symbolized_data
        @symbolized_data ||= data.deep_symbolize_keys
      end

      def yaml
        data.to_yaml
      end

      class << self
        include Searchable

        # @!method search_by_filter(filter)
        #   @param [Mihari::Structs::Filters::Search] filter
        #   @return [Array<Mihari::Models::Alert>]

        # @!method count_by_filter(filter)
        #   @param [Mihari::Structs::Filters::Search] filter
        #   @return [Integer]
      end
    end
  end
end
