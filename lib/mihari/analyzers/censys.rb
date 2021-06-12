# frozen_string_literal: true

require "censu"

module Mihari
  module Analyzers
    class Censys < Base
      param :query
      option :title, default: proc { "Censys lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }
      option :type, default: proc { "ipv4" }

      def artifacts
        case type
        when "ipv4"
          ipv4_lookup
        when "websites"
          websites_lookup
        when "certificates"
          certificates_lookup
        else
          raise InvalidInputError, "#{type} type is not supported." unless valid_type?
        end
      end

      private

      def valid_type?
        %w[ipv4 websites certificates].include? type
      end

      def normalize(domain)
        return domain unless domain.start_with?("*.")

        domain.sub("*.", "")
      end

      def ipv4_lookup
        ipv4s = []

        res = api.ipv4.search(query: query)
        res.each_page do |page|
          ipv4s << page.map(&:ip)
        end

        ipv4s.flatten
      end

      def websites_lookup
        domains = []

        res = api.websites.search(query: query)
        res.each_page do |page|
          domains << page.map(&:domain)
        end

        domains.flatten
      end

      def certificates_lookup
        domains = []

        res = api.certificates.search(query: query)
        res.each_page do |page|
          page.each do |result|
            subject_dn = result.subject_dn
            names = subject_dn.scan(/CN=(.+)/).flatten.first
            next unless names

            domains << names.split(",").map { |domain| normalize(domain) }
          end
        end

        domains.flatten
      end

      def configuration_keys
        %w[censys_id censys_secret]
      end

      def api
        @api ||= ::Censys::API.new(Mihari.config.censys_id, Mihari.config.censys_secret)
      end
    end
  end
end
