# frozen_string_literal: true

module Mihari
  module Emitters
    #
    # Database emitter
    #
    class Database < Base
      #
      # Create an alert
      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      # @return [Mihari::Models::Alert, nil]
      #
      def emit(artifacts)
        return if artifacts.empty?

        tags = rule.tags.filter_map { |name| Models::Tag.find_or_create_by(name: name) }.uniq
        taggings = tags.map { |tag| Models::Tagging.new(tag_id: tag.id) }

        alert = Models::Alert.new(artifacts: artifacts, taggings: taggings, rule_id: rule.id)
        alert.save
        alert
      end

      def configuration_keys
        %w[database_url]
      end
    end
  end
end
