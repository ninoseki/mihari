# frozen_string_literal: true

module Mihari
  class TheHive
    # @return [true, false]
    def api_endpont?
      ENV.key? "THEHIVE_API_ENDPOINT"
    end

    # @return [true, false]
    def api_key?
      ENV.key? "THEHIVE_API_KEY"
    end

    # @return [true, false]
    def valid?
      api_endpont? && api_key?
    end

    # @return [Hachi::API]
    def api
      @api ||= Hachi::API.new
    end

    # @return [Hash]
    def search(data:, data_type:, range: "all")
      api.artifact.search(data: data, data_type: data_type, range: range)
    end

    # @return [true, false]
    def exists?(data:, data_type:)
      res = search(data: data, data_type: data_type, range: "0-1")
      !res.empty?
    end

    # @return [Hash]
    def create_alert(title:, description:, artifacts:, tags: [])
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
