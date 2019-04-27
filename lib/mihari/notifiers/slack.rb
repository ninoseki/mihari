# frozen_string_literal: true

require "slack/incoming/webhooks"
require "digest/sha2"
require "mem"

module Mihari
  module Notifiers
    class Attachment
      include Mem

      attr_reader :data, :data_type

      def initialize(data:, data_type:)
        @data = data
        @data_type = data_type
      end

      def vt_link
        return nil unless _vt_link

        {
          fallback: "VT link",
          title: data,
          title_link: _vt_link,
          footer: "virustotal.com",
          footer_icon: "http://www.google.com/s2/favicons?domain=virustotal.com"
        }
      end

      def urlscan_link
        return nil unless _urlscan_link

        {
          fallback: "urlscan.io link",
          title: data,
          title_link: _urlscan_link,
          footer: "urlscan.io",
          footer_icon: "http://www.google.com/s2/favicons?domain=urlscan.io"
        }
      end

      # @return [Array]
      def to_a
        [vt_link, urlscan_link].compact
      end

      private

      # @return [String]
      def _urlscan_link
        case data_type
        when "ip"
          "https://urlscan.io/ip/#{data}"
        when "domain"
          "https://urlscan.io/domain/#{data}"
        when "url"
          uri = URI(data)
          "https://urlscan.io/domain/#{uri.hostname}"
        end
      end
      memoize :_urlscan_link

      # @return [String]
      def _vt_link
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
        end
      end
      memoize :_vt_link

      # @return [String]
      def sha256
        Digest::SHA256.hexdigest data
      end
    end

    class Slack < Base
      SLACK_WEBHOOK_URL_KEY = "SLACK_WEBHOOK_URL"
      SLACK_CHANNEL_KEY = "SLACK_CHANNEL"

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

      def to_attachments(artifacts)
        artifacts.map do |artifact|
          Attachment.new(data: artifact.data, data_type: artifact.data_type).to_a
        end.flatten
      end

      def notify(title:, description:, artifacts:)
        return if artifacts.empty?

        attachments = to_attachments(artifacts)

        slack = ::Slack::Incoming::Webhooks.new(slack_webhook_url, channel: slack_channel)
        slack.post("#{title} (#{description})", attachments: attachments)
      end
    end
  end
end
