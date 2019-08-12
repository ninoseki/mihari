# frozen_string_literal: true

module Mihari
  class AlertViewer
    attr_reader :limit
    attr_reader :the_hive

    ALERT_KEYS = %w(title description artifacts tags createdAt status).freeze

    def initialize(limit: 5)
      @limit = limit
      validate_limit

      @the_hive = TheHive.new
      raise Error, "Cannot connect to the TheHive instance" unless the_hive.valid?
    end

    def list
      range = limit == "all" ? "all" : "0-#{limit}"
      alerts = the_hive.alert.list(range: range)
      alerts.map { |alert| convert alert }
    end

    private

    def validate_limit
      return true if limit == "all"

      raise ArgumentError, "limit should be bigger than zero" unless limit.to_i.positive?
    end

    def convert(alert)
      attributes = alert.select { |k, _v| ALERT_KEYS.include? k }
      attributes["createdAt"] = Time.at(attributes["createdAt"] / 1000).to_s
      attributes["artifacts"] = (attributes.dig("artifacts") || []).map do |artifact|
        artifact.dig("data")
      end.sort
      attributes
    end
  end
end
