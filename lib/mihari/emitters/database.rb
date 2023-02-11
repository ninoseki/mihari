# frozen_string_literal: true

module Mihari
  module Emitters
    class Database < Base
      def valid?
        true
      end

      def emit(title:, description:, artifacts:, rule_id:, tags: [])
        return if artifacts.empty?

        tags = tags.filter_map { |name| Tag.find_or_create_by(name: name) }.uniq
        taggings = tags.map { |tag| Tagging.new(tag_id: tag.id) }

        alert = Alert.new(
          title: title,
          description: description,
          artifacts: artifacts,
          taggings: taggings,
          rule_id: rule_id
        )
        alert.save
        alert
      end
    end
  end
end
