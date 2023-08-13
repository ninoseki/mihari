# frozen_string_literal: true

module Mihari
  module Emitters
    class Database < Base
      def valid?
        configured?
      end

      #
      # Create an alert
      #
      # @return [Mihari::Alert, nil]
      #
      def emit
        return nil if artifacts.empty?

        tags = rule.tags.filter_map { |name| Tag.find_or_create_by(name: name) }.uniq
        taggings = tags.map { |tag| Tagging.new(tag_id: tag.id) }

        alert = Alert.new(artifacts: artifacts, taggings: taggings, rule_id: rule.id)
        alert.save
        alert
      end

      def configuration_keys
        %w[database_url]
      end
    end
  end
end
