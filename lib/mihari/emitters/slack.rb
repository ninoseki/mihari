# frozen_string_literal: true

require "slack-notifier"
require "digest/sha2"
require "mem"

module Mihari
  module Emitters
    class Attachment
      include Mem

      attr_reader :data, :data_type

      def initialize(data:, data_type:)
        @data = data
        @data_type = data_type
      end

      def actions
        [vt_link, urlscan_link, censys_link].compact
      end

      def vt_link
        return nil unless _vt_link

        { type: "button", text: "Lookup on VirusTotal", url: _vt_link, }
      end

      def urlscan_link
        return nil unless _urlscan_link

        { type: "button", text: "Lookup on urlscan.io", url: _urlscan_link, }
      end

      def censys_link
        return nil unless _censys_link

        { type: "button", text: "Lookup on Censys", url: _censys_link, }
      end

      # @return [Array]
      def to_a
        [
          {
            text: defanged_data,
            fallback: "VT & urlscan.io links",
            actions: actions
          }
        ]
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

      def _censys_link
        data_type == "ip" ? "https://censys.io/ipv4/#{data}" : nil
      end
      memoize :_censys_link

      # @return [String]
      def sha256
        Digest::SHA256.hexdigest data
      end

      # @return [String]
      def defanged_data
        @defanged_data ||= data.to_s.gsub /\./, "[.]"
      end
    end

    class Slack < Base
      def notifier
        @notifier ||= Notifiers::Slack.new
      end

      def valid?
        notifier.valid?
      end

      def to_attachments(artifacts)
        artifacts.map do |artifact|
          Attachment.new(data: artifact.data, data_type: artifact.data_type).to_a
        end.flatten
      end

      def emit(title:, description:, artifacts:, tags: [])
        return if artifacts.empty?

        attachments = to_attachments(artifacts)
        tags = ["N/A"] if tags.empty?
        text = "#{title} (desc.: #{description} / tags: #{tags.join(', ')})"

        notifier.notify(text: text, attachments: attachments)
      end

      private

      def keys
        %w(SLACK_WEBHOOK_URL)
      end
    end
  end
end
