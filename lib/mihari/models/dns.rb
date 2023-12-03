# frozen_string_literal: true

module Mihari
  module Models
    #
    # DNS record model
    #
    class DnsRecord < ActiveRecord::Base
      belongs_to :artifact

      class << self
        include Dry::Monads[:result]

        #
        # Build DNS records
        #
        # @param [String] domain
        # @param [Mihari::Enrichers::Shodan] enricher
        #
        # @return [Array<Mihari::Models::DnsRecord>]
        #
        def build_by_domain(domain, enricher: Enrichers::GooglePublicDNS.new)
          result = enricher.result(domain).bind do |res|
            Success(
              res.answers.map { |answer| new(resource: answer.resource_type, value: answer.data) }
            )
          end
          result.value_or []
        end
      end
    end
  end
end
