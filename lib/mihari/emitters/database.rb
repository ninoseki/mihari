# frozen_string_literal: true

module Mihari
  module Emitters
    class Database < Base
      def valid?
        true
      end

      #
      # Create an alert
      #
      # @param [Arra<Mihari::Artifact>] artifacts
      # @param [Mihari::Structs::Rule] rule
      #
      # @return [Mihari::Alert]
      #
      def emit(artifacts:, rule:)
        return if artifacts.empty?

        tags = rule.tags.filter_map { |name| Tag.find_or_create_by(name: name) }.uniq
        taggings = tags.map { |tag| Tagging.new(tag_id: tag.id) }

        alert = Alert.new(
          artifacts: artifacts,
          taggings: taggings,
          rule_id: rule.id
        )
        alert.save
        alert
      end
    end
  end
end
