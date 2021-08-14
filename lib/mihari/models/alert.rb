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
      # @param [String, nil] from_at
      # @param [String, nil] to_at
      # @param [Integer, nil] limit
      # @param [Integer, nil] page
      #
      # @return [Array<Hash>]
      #
      def search(artifact_data: nil, description: nil, source: nil, tag_name: nil, title: nil, from_at: nil, to_at: nil, limit: 10, page: 1)
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
          to_at: to_at
        )

        alerts = relation.limit(limit).offset(offset).order(id: :desc)

        alerts.map do |alert|
          json = AlertSerializer.new(alert).as_json
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
      # @param [String, nil] from_at
      # @param [String, nil] to_at
      #
      # @return [Integer]
      #
      def count(artifact_data: nil, description: nil, source: nil, tag_name: nil, title: nil, from_at: nil, to_at: nil)
        relation = build_relation(
          artifact_data: artifact_data,
          title: title,
          description: description,
          source: source,
          tag_name: tag_name,
          from_at: from_at,
          to_at: to_at
        )
        relation.distinct("alerts.id").count
      end

      private

      def build_relation(artifact_data: nil, title: nil, description: nil, source: nil, tag_name: nil, from_at: nil, to_at: nil)
        relation = self
        relation = joins(:tags) if tag_name
        relation = joins(:artifacts) if artifact_data

        relation = relation.where(artifacts: { data: artifact_data }) if artifact_data
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
