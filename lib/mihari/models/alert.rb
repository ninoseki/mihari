# frozen_string_literal: true

module Mihari
  module Models
    #
    # Alert model
    #
    class Alert < ActiveRecord::Base
      belongs_to :rule

      has_many :artifacts, dependent: :destroy
      has_many :tags, through: :rule

      include SearchCop

      search_scope :search do
        attributes :id, :created_at, "rule.id", "rule.title", "rule.description"
        attributes "artifact.data" => "artifacts.data"
        attributes "artifact.data_type" => "artifacts.data_type"
        attributes "artifact.source" => "artifacts.source"
        attributes "artifact.query" => "artifacts.query"
        attributes tag: "tags.name"
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
