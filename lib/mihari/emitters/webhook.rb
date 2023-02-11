# frozen_string_literal: true

module Mihari
  module Emitters
    class Webhook < Base
      # @return [Boolean]
      def valid?
        webhook_url?
      end

      def emit(title:, description:, artifacts:, rule_id:, tags:)
        return if artifacts.empty?

        headers = { "content-type": "application/x-www-form-urlencoded" }
        headers["content-type"] = "application/json" if use_json_body?

        emitter = Emitters::HTTP.new(uri: Mihari.config.webhook_url)
        emitter.emit(title: title, description: description, artifacts: artifacts, rule_id: rule_id, tags: tags)
      end

      private

      def configuration_keys
        %w[webhook_url]
      end

      #
      # Webhook URL
      #
      # @return [String, nil]
      #
      def webhook_url
        @webhook_url ||= Mihari.config.webhook_url
      end

      #
      # Check whether a webhook URL is set or not
      #
      # @return [Boolean]
      #
      def webhook_url?
        !webhook_url.nil?
      end

      #
      # Check whether to use JSON body or not
      #
      # @return [Boolean]
      #
      def use_json_body?
        @use_json_body ||= Mihari.config.webhook_use_json_body
      end
    end
  end
end
