# frozen_string_literal: true

module Mihari
  class TheHive
    class Alert < Base
      # @return [Array]
      def list(range: "all", sort: "-date")
        alerts = api.alert.search({ source: "mihari" }, range: range, sort: sort)
        alerts.sort_by { |alert| -alert.dig("createdAt") }
      end

      # @return [Hash]
      def create(title:, description:, artifacts:, tags: [])
        api.alert.create(
          title: title,
          description: description,
          artifacts: artifacts,
          tags: tags,
          type: "external",
          source: "mihari"
        )
      end
    end
  end
end
