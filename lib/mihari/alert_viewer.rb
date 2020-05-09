# frozen_string_literal: true

module Mihari
  class AlertViewer
    def list(title: nil, source: nil, tag: nil, limit: 5)
      limit = limit.to_i
      raise ArgumentError, "limit should be bigger than zero" unless limit.positive?

      relation = Alert.includes(:tags, :artifacts)
      relation = relation.where(title: title) if title
      relation = relation.where(source: source) if source
      relation = relation.where(tags: { name: tag } ) if tag

      alerts = relation.limit(limit).order(id: :desc)
      alerts.map do |alert|
        json = AlertSerializer.new(alert).as_json
        json[:artifacts] = (json.dig(:artifacts) || []).map { |artifact_| artifact_.dig(:data) }
        json[:tags] = (json.dig(:tags) || []).map { |tag_| tag_.dig(:name) }
        json
      end
    end
  end
end
