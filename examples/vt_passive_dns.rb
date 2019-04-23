# frozen_string_literal: true

$LOAD_PATH.unshift("#{__dir__}/../lib")

require "mihari"

require "virustotal_api"

module Mihari
  module Analyzers
    class VTPassiveDNS < Base
      attr_reader :ip

      def initialize(ip, api_key: nil)
        @ip = ip
        @api_key = api_key
      end

      def title
        "VT passive DNS"
      end

      def description
        "VT passive DNS: #{ip}"
      end

      def api_key
        ENV["VT_API_KEY"] || @api_key
      end

      def artifacts
        ip_report = VirustotalAPI::IPReport.find(ip, api_key)
        return [] unless ip_report.exists?

        report = ip_report.report
        report.dig("resolutions")&.map do |resolution|
          resolution.dig("hostname")
        end&.compact
      end
    end
  end
end

ip = "TARGET_IP"
analyzer = Mihari::Analyzers::VTPassiveDNS.new(ip)
analyzer.run
