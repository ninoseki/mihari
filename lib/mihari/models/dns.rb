# frozen_string_literal: true

module Mihari
  module Models
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
          result = enricher.query_result(domain).bind do |responses|
            Success(
              responses.map do |res|
                res.answers.map do |answer|
                  new(resource: answer.resource_type, value: answer.data)
                end
              end.flatten
            )
          end
          result.value_or []
        end
      end
    end
  end
end
