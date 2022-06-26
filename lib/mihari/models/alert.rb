# frozen_string_literal: true

module Mihari
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
        eager_load(
          {
            artifacts: [
              :autonomous_system,
              :geolocation,
              :whois_record,
              :dns_records,
              :reverse_dns_names,
              :cpes,
              :ports
            ]
          },
          :tags
        ).where(id: [alert_ids]).order(id: :desc)
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
      # @return [Mihari::Alert]
      #
      def build_relation(filter)
        artifact_ids = []
        artifact = Artifact.includes(:autonomous_system, :dns_records, :reverse_dns_names)
        artifact = artifact.where(data: filter.artifact_data) if filter.artifact_data
        artifact = artifact.where(autonomous_system: { asn: filter.asn }) if filter.asn
        artifact = artifact.where(dns_records: { value: filter.dns_record }) if filter.dns_record
        artifact = artifact.where(reverse_dns_names: { name: filter.reverse_dns_name }) if filter.reverse_dns_name
        # get artifact ids if there is any valid filter for artifact
        if filter.valid_artifact_filters?
          artifact_ids = artifact.pluck(:id)
          # set invalid ID if nothing is matched with the filters
          artifact_ids = [-1] if artifact_ids.empty?
        end

        relation = self
        relation = relation.includes(:artifacts, :tags)

        relation = relation.where(artifacts: { id: artifact_ids }) unless artifact_ids.empty?
        relation = relation.where(tags: { name: filter.tag_name }) if filter.tag_name

        relation = relation.where(source: filter.source) if filter.source
        relation = relation.where(title: filter.title) if filter.title

        relation = relation.where("description LIKE ?", "%#{filter.description}%") if filter.description

        relation = relation.where("alerts.created_at >= ?", filter.from_at) if filter.from_at
        relation = relation.where("alerts.created_at <= ?", filter.to_at) if filter.to_at

        relation
      end
    end
  end
end
