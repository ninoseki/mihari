# frozen_string_literal: true

module Mihari
  module Models
    #
    # Whois record model
    #
    class WhoisRecord < ActiveRecord::Base
      belongs_to :artifact

      class << self
        #
        # Build whois record
        #
        # @param [String] domain
        # @param [Mihari::Enrichers::Whois] enricher
        #
        # @return [WhoisRecord, nil]
        #
        def build_by_domain(domain, enricher: Enrichers::Whois.new)
          enricher.result(domain).value_or nil
        end
      end
    end
  end
end
