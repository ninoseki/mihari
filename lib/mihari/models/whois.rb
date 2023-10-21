# frozen_string_literal: true

module Mihari
  class WhoisRecord < ActiveRecord::Base
    belongs_to :artifact

    @memo = {}

    class << self
      include Dry::Monads[:result]

      #
      # Build whois record
      #
      # @param [String] domain
      # @param [Mihari::Enrichers::Whois] enricher
      #
      # @return [WhoisRecord, nil]
      #
      def build_by_domain(domain, enricher: Enrichers::Whois.new)
        result = enricher.query_result(domain)
        result.value_or nil
      end
    end
  end
end
