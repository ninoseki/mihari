# frozen_string_literal: true

require "yaml"

module Mihari
  class Rule < ActiveRecord::Base
    has_many :alerts, foreign_key: :source

    def symbolized_data
      @symbolized_data ||= data.deep_symbolize_keys
    end

    #
    # Returns a hash representative
    #
    # @return [Hash]
    #
    def to_h
      {
        id: id,
        yaml: yaml || data.to_yaml,
        created_at: created_at,
        updated_at: updated_at
      }
    end

    class << self
      #
      # Search rules
      #
      # @param [Structs::Filters::Rule::SearchFilterWithPagination] filter
      #
      # @return [Array<Rule>]
      #
      def search(filter)
        limit = filter.limit.to_i
        raise ArgumentError, "limit should be bigger than zero" unless limit.positive?

        page = filter.page.to_i
        raise ArgumentError, "page should be bigger than zero" unless page.positive?

        offset = (page - 1) * limit

        relation = build_relation(filter.without_pagination)

        # TODO: improve queires
        rule_ids = relation.limit(limit).offset(offset).order(created_at: :desc).pluck(:id).uniq
        where(id: [rule_ids]).order(created_at: :desc)
      end

      #
      # Count alerts
      #
      # @param [Structs::Filters::Rule::SearchFilterWithPagination] filter
      #
      # @return [Integer]
      #
      def count(filter)
        relation = build_relation(filter)
        relation.distinct("rules.id").count
      end

      private

      #
      # @param [Structs::Filters::Rule::SearchFilter] filter
      #
      # @return [Mihari::Rule]
      #
      def build_relation(filter)
        relation = self
        relation = relation.includes(alerts: :tags)

        relation = relation.where(alerts: { tags: { name: filter.tag_name } }) if filter.tag_name

        relation = relation.where(title: filter.title) if filter.title

        relation = relation.where("rules.description LIKE ?", "%#{filter.description}%") if filter.description

        relation = relation.where("rules.created_at >= ?", filter.from_at) if filter.from_at
        relation = relation.where("rules.created_at <= ?", filter.to_at) if filter.to_at

        relation
      end
    end
  end
end
