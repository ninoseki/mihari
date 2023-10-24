# frozen_string_literal: true

module Mihari
  module Models
    class AutonomousSystem < ActiveRecord::Base
      belongs_to :artifact

      class << self
        include Dry::Monads[:result]

        #
        # Build AS
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::IPInfo] enricher
        #
        # @return [Mihari::AutonomousSystem, nil]
        #
        def build_by_ip(ip, enricher: Enrichers::IPInfo.new)
          result = enricher.query_result(ip).bind do |res|
            value = res&.asn
            if value.nil?
              Success nil
            else
              Success new(asn: value)
            end
          end
          result.value_or nil
        end
      end
    end
  end
end
