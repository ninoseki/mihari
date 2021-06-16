# frozen_string_literal: true

require "slack-notifier"

module Mihari
  module Notifiers
    class Slack < Base
      SLACK_WEBHOOK_URL_KEY = "SLACK_WEBHOOK_URL"
      SLACK_CHANNEL_KEY = "SLACK_CHANNEL"
      DEFAULT_USERNAME = "mihari"

      #
      # Slack channel to post
      #
      # @return [String]
      #
      def slack_channel
        Mihari.config.slack_channel || "#general"
      end

      #
      # Slack webhook URL
      #
      # @return [String]
      #
      def slack_webhook_url
        Mihari.config.slack_webhook_url
      end

      #
      # Check Slack webhook URL is set
      #
      # @return [Boolean]
      #
      def slack_webhook_url?
        !Mihari.config.slack_webhook_url.nil?
      end

      #
      # Check Slack webhook URL is set. Alias of #slack_webhook_url?.
      #
      # @return [Boolean]
      #
      def valid?
        slack_webhook_url?
      end

      #
      # Send notification to Slack
      #
      # @param [String] text
      # @param [Array<Hash>] attachments
      # @param [Boolean] mrkdwn
      #
      # @return [nil]
      #
      def notify(text:, attachments: [], mrkdwn: true)
        notifier = ::Slack::Notifier.new(slack_webhook_url, channel: slack_channel, username: DEFAULT_USERNAME)
        notifier.post(text: text, attachments: attachments, mrkdwn: mrkdwn)
      end
    end
  end
end
