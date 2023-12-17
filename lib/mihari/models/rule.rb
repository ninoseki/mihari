# frozen_string_literal: true

require "yaml"

module Mihari
  module Models
    #
    # Rule model
    #
    class Rule < ActiveRecord::Base
      has_many :alerts, dependent: :destroy

      def symbolized_data
        @symbolized_data ||= data.deep_symbolize_keys
      end

      def yaml
        data.to_yaml
      end

      def tags
        (data["tags"] || []).map { |tag| { name: tag } }
      end

      class << self
        include Paginationable

        # @!method search(filter)
        #   @param [Mihari::Structs::Filters::Rule::SearchFilter] filter
        #   @return [Array<Mihari::Models::Rule>]

        # @!method count(filter)
        #   @param [Mihari::Structs::Filters::Rule::SearchFilter] filter
        #   @return [Integer]

        private

        #
        # @param [Mihari::Structs::Filters::Rule::SearchFilter] filter
        #
        # @return [Mihari::Models::Rule]
        #
        def build_relation(filter)
          relation = includes(alerts: :tags)

          relation = relation.where(alerts: { tags: { name: filter.tag } }) if filter.tag

          relation = relation.where("rules.title LIKE ?", "%#{filter.title}%") if filter.title
          relation = relation.where("rules.description LIKE ?", "%#{filter.description}%") if filter.description

          relation = relation.where("rules.created_at >= ?", filter.from_at) if filter.from_at
          relation = relation.where("rules.created_at <= ?", filter.to_at) if filter.to_at

          relation
        end
      end
    end
  end
end
