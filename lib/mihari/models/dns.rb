# frozen_string_literal: true

require "active_record"
require "resolv"

module Mihari
  class DnsRecord < ActiveRecord::Base
    class << self
      #
      # Build DNS records
      #
      # @param [String] domain
      #
      # @return [Array<Mihari::DnsRecord>]
      #
      def build_by_domain(domain)
        resource_types = [
          Resolv::DNS::Resource::IN::A,
          Resolv::DNS::Resource::IN::AAAA,
          Resolv::DNS::Resource::IN::CNAME,
          Resolv::DNS::Resource::IN::TXT,
          Resolv::DNS::Resource::IN::NS
        ]

        resource_types.map do |resource_type|
          get_values domain, resource_type
        end.flatten
      end

      private

      def get_values(domain, resource_type)
        resources = Resolv::DNS.new.getresources(domain, resource_type)
        resource_name = resource_type.to_s.split("::").last

        resources.map do |resource|
          # A, AAAA
          if resource.respond_to?(:address)
            new(resource: resource_name, value: resource.address.to_s)
          # CNAME, NS
          elsif resource.respond_to?(:name)
            new(resource: resource_name, value: resource.name.to_s)
          # TXT
          elsif resource.respond_to?(:data)
            new(resource: resource_name, value: resource.data.to_s)
          end
        end.compact
      end
    end
  end
end
