# frozen_string_literal: true

require "active_record"
require "active_record/filter"

module Mihari
  class Alert < ActiveRecord::Base
    has_many :taggings, dependent: :destroy
    has_many :artifacts, dependent: :destroy
    has_many :tags, through: :taggings

    class << self
      #
      # Search alerts
      #
      # @param [String, nil] artifact_data
      # @param [String, nil] description
      # @param [String, nil] source
      # @param [String, nil] tag_name
      # @param [String, nil] title
      # @param [DateTime, nil] from_at
      # @param [DateTime, nil] to_at
      # @param [Integer, nil] asn
      # @param [String, nil] dns_record
      # @param [String, nil] reverse_dns_name
      # @param [Integer, nil] limit
      # @param [Integer, nil] page
      #
      # @return [Array<Hash>]
      #
      def search(
        artifact_data: nil,
        description: nil,
        source: nil,
        tag_name: nil,
        title: nil,
        from_at: nil,
        to_at: nil,
        asn: nil,
        dns_record: nil,
        reverse_dns_name: nil,
        limit: 10,
        page: 1
      )
        limit = limit.to_i
        raise ArgumentError, "limit should be bigger than zero" unless limit.positive?

        page = page.to_i
        raise ArgumentError, "page should be bigger than zero" unless page.positive?

        offset = (page - 1) * limit

        relation = build_relation(
          artifact_data: artifact_data,
          title: title,
          description: description,
          source: source,
          tag_name: tag_name,
          from_at: from_at,
          to_at: to_at,
          asn: asn,
          dns_record: dns_record,
          reverse_dns_name: reverse_dns_name
        )

        # TODO: improve queires
        alert_ids = relation.limit(limit).offset(offset).order(id: :desc).pluck(:id).uniq
        alerts = includes(:artifacts, :tags).where(id: [alert_ids]).order(id: :desc)

        alerts.map do |alert|
          json = Serializers::AlertSerializer.new(alert).as_json
          json[:artifacts] = json[:artifacts] || []
          json[:tags] = json[:tags] || []
          json
        end
      end

      #
      # Count alerts
      #
      # @param [String, nil] artifact_data
      # @param [String, nil] description
      # @param [String, nil] source
      # @param [String, nil] tag_name
      # @param [String, nil] title
      # @param [DateTime, nil] from_at
      # @param [DateTime, nil] to_at
      # @param [Integer, nil] asn
      # @param [String, nil] dns_record
      # @param [String, nil] reverse_dns_name
      #
      # @return [Integer]
      #
      def count(
        artifact_data: nil,
        description: nil,
        source: nil,
        tag_name: nil,
        title: nil,
        from_at: nil,
        to_at: nil,
        asn: nil,
        dns_record: nil,
        reverse_dns_name: nil
      )
        relation = build_relation(
          artifact_data: artifact_data,
          title: title,
          description: description,
          source: source,
          tag_name: tag_name,
          from_at: from_at,
          to_at: to_at,
          asn: asn,
          dns_record: dns_record,
          reverse_dns_name: reverse_dns_name
        )
        relation.distinct("alerts.id").count
      end

      private

      def build_relation(
        artifact_data: nil,
        title: nil,
        description: nil,
        source: nil,
        tag_name: nil,
        from_at: nil,
        to_at: nil,
        asn: nil,
        dns_record: nil,
        reverse_dns_name: nil
      )
        artifact_ids = []
        artifact = Artifact.includes(:autonomous_system, :dns_records, :reverse_dns_names)
        artifact = artifact.where(data: artifact_data) if artifact_data
        artifact = artifact.where(autonomous_system: { asn: asn }) if asn
        artifact = artifact.where(dns_records: { value: dns_record }) if dns_record
        artifact = artifact.where(reverse_dns_names: { name: reverse_dns_name }) if reverse_dns_name
        # get artifact ids if there is any valid filter for artifact
        if artifact_data || asn || dns_record || reverse_dns_name
          artifact_ids = artifact.pluck(:id)
          # set invalid ID if nothing is matched with the filters
          artifact_ids = [-1] if artifact_ids.empty?
        end

        relation = self
        relation = relation.includes(:artifacts, :tags)

        relation = relation.where(artifacts: { id: artifact_ids }) unless artifact_ids.empty?
        relation = relation.where(tags: { name: tag_name }) if tag_name

        relation = relation.where(source: source) if source
        relation = relation.where(title: title) if title

        relation = relation.filter(description: { like: "%#{description}%" }) if description

        relation = relation.filter(created_at: { gte: from_at }) if from_at
        relation = relation.filter(created_at: { lte: to_at }) if to_at

        relation
      end
    end
  end
end
