# frozen_string_literal: true

module Mihari
  class DnsRecord < ActiveRecord::Base
    belongs_to :artifact

    class << self
      #
      # Build DNS records
      #
      # @param [String] domain
      #
      # @return [Array<Mihari::DnsRecord>]
      #
      def build_by_domain(domain)
        resource_types = %w[A AAAA CNAME TXT NS]
        resource_types.map do |resource_type|
          get_values domain, resource_type
        rescue Resolv::ResolvError
          nil
        end.flatten.compact
      end

      private

      def get_values(domain, resource_type)
        response = Enrichers::GooglePublicDNS.query(domain, resource_type)
        answers = response.answers || []

        answers.filter_map do |answer|
          new(resource: answer.resource_type, value: answer.data)
        end
      end
    end
  end
end
