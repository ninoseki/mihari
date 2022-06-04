# frozen_string_literal: true

module Mihari
  class WhoisRecord < ActiveRecord::Base
    belongs_to :artifact

    @memo = {}

    class << self
      #
      # Build whois record
      #
      # @param [Stinrg] domain
      #
      # @return [WhoisRecord, nil]
      #
      def build_by_domain(domain)
        Enrichers::Whois.query domain
      end
    end
  end
end
