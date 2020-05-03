# frozen_string_literal: true

module Mihari
  class AlertViewer
    attr_reader :limit

    def initialize(limit: 5)
      @limit = limit.to_i
      raise ArgumentError, "limit should be bigger than zero" unless @limit.positive?
    end

    def list
      alerts = Alert.order(id: :desc).limit(limit).includes(:tags, :artifacts)
      alerts.map do |alert|
        AlertSerializer.new(alert).as_json
      end
    end
  end
end
