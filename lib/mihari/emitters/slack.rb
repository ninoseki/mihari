# frozen_string_literal: true

require "slack-notifier"
require "digest/sha2"
require "dry-initializer"

module Mihari
  module Emitters
    class Attachment
      include Mem

      extend Dry::Initializer

      option :data
      option :data_type

      def actions
        [vt_link, urlscan_link, censys_link, shodan_link].compact
      end

      def vt_link
        return nil unless _vt_link

        { type: "button", text: "VirusTotal", url: _vt_link }
      end

      def urlscan_link
        return nil unless _urlscan_link

        { type: "button", text: "urlscan.io", url: _urlscan_link }
      end

      def censys_link
        return nil unless _censys_link

        { type: "button", text: "Censys", url: _censys_link }
      end

      def shodan_link
        return nil unless _shodan_link

        { type: "button", text: "Shodan", url: _shodan_link }
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
        data_type == "ip" ? "https://search.censys.io/hosts/#{data}" : nil
      end
      memoize :_censys_link

      def _shodan_link
        data_type == "ip" ? "https://www.shodan.io/host/#{data}" : nil
      end
      memoize :_shodan_link

      # @return [String]
      def sha256
        Digest::SHA256.hexdigest data
      end

      # @return [String]
      def defanged_data
        @defanged_data ||= data.to_s.gsub(/\./, "[.]")
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

      def to_text(title:, description:, tags: [])
        tags = ["N/A"] if tags.empty?

        [
          "*#{title}*",
          "*Desc.*: #{description}",
          "*Tags*: #{tags.join(", ")}"
        ].join("\n")
      end

      def emit(title:, description:, artifacts:, tags: [], **_options)
        return if artifacts.empty?

        attachments = to_attachments(artifacts)
        text = to_text(title: title, description: description, tags: tags)

        notifier.notify(text: text, attachments: attachments)
      end

      private

      def configuration_keys
        %w[slack_webhook_url]
      end
    end
  end
end
