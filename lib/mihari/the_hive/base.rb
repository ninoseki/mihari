# frozen_string_literal: true

require "hachi"

module Mihari
  class TheHive
    class Base
      # @return [Hachi::API]
      def api
        @api ||= Hachi::API.new(api_endpoint: Mihari.config.thehive_api_endpoint, api_key: Mihari.config.thehive_api_key)
      end
    end
  end
end
