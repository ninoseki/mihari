# frozen_string_literal: true

module Mihari
  module Models
    #
    # Rule model
    #
    class Rule < ActiveRecord::Base
      # @!attribute [rw] id
      #   @return [String]

      # @!attribute [rw] title
      #   @return [String]

      # @!attribute [rw] description
      #   @return [String]

      # @!attribute [rw] data
      #   @return [Hash]

      # @!attribute [rw] created_at
      #   @return [DateTime]

      # @!attribute [rw] updated_at
      #   @return [DateTime]

      # @!attribute [r] alerts
      #   @return [Array<Mihari::Models::Alert>]

      has_many :alerts, dependent: :destroy
      has_many :taggings, dependent: :destroy
      has_many :tags, through: :taggings

      include SearchCop
      include Concerns::Searchable

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
