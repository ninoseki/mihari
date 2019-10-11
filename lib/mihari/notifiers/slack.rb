# frozen_string_literal: true

module Mihari
  module Notifiers
    class Slack < Base
      SLACK_WEBHOOK_URL_KEY = "SLACK_WEBHOOK_URL"
      SLACK_CHANNEL_KEY = "SLACK_CHANNEL"
      DEFAULT_USERNAME = "mihari"

      def slack_channel
        ENV.fetch SLACK_CHANNEL_KEY, "#general"
      end

      def slack_webhook_url
        ENV.fetch SLACK_WEBHOOK_URL_KEY
      end

      def slack_webhook_url?
        ENV.key? SLACK_WEBHOOK_URL_KEY
      end

      def valid?
        slack_webhook_url?
      end

      def notify(text:, attachments: [], mrkdwn: true)
        notifier = ::Slack::Notifier.new(slack_webhook_url, channel: slack_channel, username: DEFAULT_USERNAME)
        notifier.post(text: text, attachments: attachments, mrkdwn: true)
      end
    end
  end
end
