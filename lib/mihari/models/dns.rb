# frozen_string_literal: true

module Mihari
  module Models
    #
    # DNS record model
    #
    class DnsRecord < ActiveRecord::Base
      belongs_to :artifact

      class << self
        #
        # Build DNS records
        #
        # @param [String] domain
        # @param [Mihari::Enrichers::Shodan] enricher
        #
        # @return [Array<Mihari::Models::DnsRecord>]
        #
        def build_by_domain(domain, enricher: Enrichers::GooglePublicDNS.new)
          enricher.result(domain).fmap do |res|
            res.answers.map { |answer| new(resource: answer.resource_type, value: answer.data) }
          end.value_or([])
        end
      end
    end
  end
end
