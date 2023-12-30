# frozen_string_literal: true

module Mihari
  module Models
    #
    # AS model
    #
    class AutonomousSystem < ActiveRecord::Base
      belongs_to :artifact

      class << self
        #
        # Build AS
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::MMDB] enricher
        #
        # @return [Mihari::AutonomousSystem, nil]
        #
        def build_by_ip(ip, enricher: Enrichers::MMDB.new)
          enricher.result(ip).fmap do |res|
            value = res&.asn
            value.nil? ? nil : new(asn: value)
          end.value_or nil
        end
      end
    end
  end
end
