# frozen_string_literal: true

require "digest/sha2"
require "slack-notifier"

module Mihari
  module Emitters
    class Attachment
      prepend MemoWise

      # @return [String]
      attr_reader :data

      # @return [String]
      attr_reader :data_type

      #
      # @param [String] data
      # @param [String] data_type
      #
      def initialize(data:, data_type:)
        @data = data
        @data_type = data_type
      end

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

      # @return [String, nil]
      def _urlscan_link
        case data_type
        when "ip"
          "https://urlscan.io/ip/#{data}"
        when "domain"
          "https://urlscan.io/domain/#{data}"
        when "url"
          uri = Addressable::URI.parse(data)
          "https://urlscan.io/domain/#{uri.hostname}"
        end
      end
      memo_wise :_urlscan_link

      # @return [String, nil]
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
      memo_wise :_vt_link

      # @return [String, nil]
      def _censys_link
        (data_type == "ip") ? "https://search.censys.io/hosts/#{data}" : nil
      end
      memo_wise :_censys_link

      # @return [String, nil]
      def _shodan_link
        (data_type == "ip") ? "https://www.shodan.io/host/#{data}" : nil
      end
      memo_wise :_shodan_link

      # @return [String]
      def sha256
        Digest::SHA256.hexdigest data
      end

      # @return [String]
      def defanged_data
        @defanged_data ||= data.to_s.gsub(".", "[.]")
      end
    end

    class Slack < Base
      DEFAULT_CHANNEL = "#general"
      DEFAULT_USERNAME = "Mihari"

      # @return [String, nil]
      attr_reader :webhook_url

      # @return [String]
      attr_reader :channel

      # @return [String]
      attr_reader :username

      # @return [Array<Mihari::Models::Artifact>]
      attr_accessor :artifacts

      #
      # @param [Mihari::Rule] rule
      # @param [Hash, nil] options
      # @param [Hash, nil] params
      #
      def initialize(rule:, options: nil, **params)
        super(rule: rule, options: options)

        @webhook_url = params[:webhook_url] || Mihari.config.slack_webhook_url
        @channel = params[:channel] || Mihari.config.slack_channel || DEFAULT_CHANNEL
        @username = DEFAULT_USERNAME

        @artifacts = []
      end

      #
      # Check webhook URL is set
      #
      # @return [Boolean]
      #
      def webhook_url?
        !webhook_url.nil?
      end

      #
      # @return [Boolean]
      #
      def configured?
        webhook_url?
      end

      #
      # @return [::Slack::Notifier]
      #
      def notifier
        @notifier ||= [].tap do |out|
          out << if timeout.nil?
            ::Slack::Notifier.new(
              webhook_url,
              channel: channel, username: username
            )
          else
            ::Slack::Notifier.new(
              webhook_url,
              channel: channel,
              username: username,
              http_options: { timeout: timeout }
            )
          end
        end.first
      end

      #
      # Build attachments
      #
      # @return [Array<Mihari::Emitters::Attachment>]
      #
      def attachments
        artifacts.map { |artifact| Attachment.new(data: artifact.data, data_type: artifact.data_type).to_a }.flatten
      end

      #
      # Build a text
      #
      # @return [String]
      #
      def text
        tags = rule.tags
        tags = ["N/A"] if tags.empty?
        [
          "*#{rule.title}*",
          "*Desc.*: #{rule.description}",
          "*Tags*: #{tags.join(", ")}"
        ].join("\n")
      end

      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      def call(artifacts)
        @artifacts = artifacts

        return if artifacts.empty?

        notifier.post(text: text, attachments: attachments, mrkdwn: true)
      end

      def configuration_keys
        %w[slack_webhook_url slack_channel]
      end
    end
  end
end
