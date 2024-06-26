# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # VirusTotal analyzer
    #
    class VirusTotal < Base
      include Concerns::Refangable

      # @return [String]
      attr_reader :type

      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(refang(query), options:)

        @type = DataType.type(query)

        @api_key = api_key || Mihari.config.virustotal_api_key
      end

      def artifacts
        case type
        when "domain"
          domain_search
        when "ip"
          ip_search
        else
          raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      class << self
        #
        # @return [Array<String>, nil]
        #
        def key_aliases
          ["vt"]
        end
      end

      private

      def client
        Clients::VirusTotal.new(api_key:)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain].include? type
      end

      #
      # Domain search
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def domain_search
        res = client.domain_search(query)

        data = res["data"] || []
        data.filter_map do |item|
          data = item.dig("attributes", "ip_address")
          data.nil? ? nil : Models::Artifact.new(data:, metadata: item)
        end
      end

      #
      # IP search
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def ip_search
        res = client.ip_search(query)

        data = res["data"] || []
        data.filter_map do |item|
          data = item.dig("attributes", "host_name")
          Models::Artifact.new(data:, metadata: item)
        end.uniq
      end
    end
  end
end
