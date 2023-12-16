# frozen_string_literal: true

module Mihari
  module Models
    #
    # Alert model
    #
    class Alert < ActiveRecord::Base
      has_many :taggings, dependent: :destroy
      has_many :artifacts, dependent: :destroy
      has_many :tags, through: :taggings

      belongs_to :rule

      class << self
        #
        # Search alerts
        #
        # @param [Mihari::Structs::Filters::Alert::SearchFilterWithPagination] filter
        #
        # @return [Array<Alert>]
        #
        def search(filter)
          limit = filter.limit.to_i
          raise ArgumentError, "limit should be bigger than zero" unless limit.positive?

          page = filter.page.to_i
          raise ArgumentError, "page should be bigger than zero" unless page.positive?

          offset = (page - 1) * limit

          relation = build_relation(filter.without_pagination)
          relation.limit(limit).offset(offset).order(id: :desc)
        end

        #
        # Count alerts
        #
        # @param [Mihari::Structs::Filters::Alert::SearchFilter] filter
        #
        # @return [Integer]
        #
        def count(filter)
          relation = build_relation(filter)
          relation.distinct("alerts.id").count
        end

        private

        #
        # @param [Mihari::Structs::Filters::Alert::SearchFilter] filter
        #
        # @return [Mihari::Models::Alert]
        #
        def build_relation(filter)
          relation = eager_load(:artifacts, :tags)

          relation = relation.where(artifacts: { data: filter.artifact }) if filter.artifact
          relation = relation.where(tags: { name: filter.tag }) if filter.tag
          relation = relation.where(rule_id: filter.rule_id) if filter.rule_id
          relation = relation.where("alerts.created_at >= ?", filter.from_at) if filter.from_at
          relation = relation.where("alerts.created_at <= ?", filter.to_at) if filter.to_at

          relation
        end
      end
    end
  end
end
