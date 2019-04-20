# frozen_string_literal: true

require "slack/incoming/webhooks"
require "digest/sha2"

module Mihari
  module Notifiers
    class Attachment
      attr_reader :data, :data_type

      def initialize(data:, data_type:)
        @data = data
        @data_type = data_type
      end

      def link
        case data_type
        when "hash"
          "https://www.virustotal.com/#/file/#{data}"
        when "ip"
          "https://www.virustotal.com/#/ip-address/#{data}"
        when "domain"
          "https://www.virustotal.com/#/domain/#{data}"
        when "url"
          "https://www.virustotal.com/#/url/#{sha256}"
        when "mail"
          "https://www.virustotal.com/#/search/#{data}"
        else
          ""
        end
      end

      def to_h
        {
          fallback: "VT link",
          title: data,
          title_link: link,
          footer: "virustotal.com",
          footer_icon: "http://www.google.com/s2/favicons?domain=virustotal.com"
        }
      end

      private

      def sha256
        Digest::SHA256.hexdigest data
      end
    end

    class Slack
      def slack_channel
        ENV.fetch "SLACK_CHANNEL", "#general"
      end

      def slack_webhook_url
        ENV.fetch "SLACK_WEBHOOK_URL"
      end

      def slack_webhook_url?
        ENV.key? "SLACK_WEBHOOK_URL"
      end

      def valid?
        slack_webhook_url?
      end

      def to_attachments(artifacts)
        artifacts.map do |artifact|
          Attachment.new(data: artifact.data, data_type: artifact.data_type).to_h
        end
      end

      def notify(title:, description:, artifacts:)
        return if artifacts.empty?

        attachments = to_attachments(artifacts)

        slack = Slack::Incoming::Webhooks.new(slack_webhook_url, channel: slack_channel)
        slack.post("#{title}: #{description}", attachments: attachments)
      end
    end
  end
end
