# frozen_string_literal: true

module Mihari
  module Models
    class Alert < ActiveRecord::Base
      has_many :taggings, dependent: :destroy
      has_many :artifacts, dependent: :destroy
      has_many :tags, through: :taggings

      belongs_to :rule

      class << self
        #
        # Search alerts
        #
        # @param [Structs::Filters::Alert::SearchFilterWithPagination] filter
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

          alert_ids = relation.limit(limit).offset(offset).order(id: :desc).pluck(:id).uniq
          eager_load(:artifacts, :tags).where(id: [alert_ids]).order(id: :desc)
        end

        #
        # Count alerts
        #
        # @param [String, nil] artifact_data
        #
        # @return [Integer]
        #
        def count(filter)
          relation = build_relation(filter)
          relation.distinct("alerts.id").count
        end

        private

        #
        # @param [Structs::Filters::Alert::SearchFilter] filter
        #
        # @return [Array<Integer>]
        #
        def get_artifact_ids_by_filter(filter)
          artifact_ids = []

          if filter.artifact_data
            artifact = Artifact.where(data: filter.artifact_data)
            artifact_ids = artifact.pluck(:id)
            # set invalid ID if nothing is matched with the filters
            artifact_ids = [-1] if artifact_ids.empty?
          end

          artifact_ids
        end

        #
        # @param [Structs::Filters::Alert::SearchFilter] filter
        #
        # @return [Mihari::Models::Alert]
        #
        def build_relation(filter)
          artifact_ids = get_artifact_ids_by_filter(filter)

          relation = self
          relation = relation.includes(:artifacts, :tags)

          relation = relation.where(artifacts: { id: artifact_ids }) unless artifact_ids.empty?
          relation = relation.where(tags: { name: filter.tag_name }) if filter.tag_name

          relation = relation.where(rule_id: filter.rule_id) if filter.rule_id

          relation = relation.where("alerts.created_at >= ?", filter.from_at) if filter.from_at
          relation = relation.where("alerts.created_at <= ?", filter.to_at) if filter.to_at

          relation
        end
      end
    end
  end
end
