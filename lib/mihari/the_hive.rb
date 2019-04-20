# frozen_string_literal: true

module Mihari
  class TheHive
    def api_endpont?
      ENV.key? "THEHIVE_API_ENDPOINT"
    end

    def api_key?
      ENV.key? "THEHIVE_API_KEY"
    end

    def valid?
      api_endpont? && api_key?
    end

    def api
      @api ||= Hachi::API.new
    end

    def search(data:, data_type:, range: "all")
      api.artifact.search(data: data, data_type: data_type, range: range)
    end

    def exists?(data:, data_type:)
      res = search(data: data, data_type: data_type, range: "0-1")
      !res.empty?
    end

    def create_alert(title:, description:, artifacts:)
      api.alert.create(title: title, description: description, artifacts: artifacts, type: "external", source: "mihari")
    end
  end
end
