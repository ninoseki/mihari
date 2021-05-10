# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Mihari
  module Emitters
    class Webhook < Base
      # @return [true, false]
      def valid?
        webhook_url?
      end

      def emit(title:, description:, artifacts:, source:, tags:)
        return if artifacts.empty?

        uri = URI(Mihari.config.webhook_url)
        data = {
          title: title,
          description: description,
          artifacts: artifacts.map(&:data),
          source: source,
          tags: tags
        }

        if use_json_body
          Net::HTTP.post(uri, data.to_json, "Content-Type" => "application/json")
        else
          Net::HTTP.post_form(uri, data)
        end
      end

      private

      def config_keys
        %w[webhook_url]
      end

      def webhook_url
        @webhook_url ||= Mihari.config.webhook_url
      end

      def webhook_url?
        !webhook_url.nil?
      end

      def use_json_body
        @use_json_body ||= truthy?(Mihari.config.webhook_use_json_body || 'false')
      end

      def truthy?(value)
        return true if value == "true"
        return true if value == true

        false
      end
    end
  end
end
