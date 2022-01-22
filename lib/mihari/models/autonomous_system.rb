# frozen_string_literal: true

module Mihari
  class AutonomousSystem < ActiveRecord::Base
    belongs_to :artifact

    class << self
      #
      # Build AS
      #
      # @param [String] ip
      #
      # @return [Mihari::AutonomousSystem, nil]
      #
      def build_by_ip(ip)
        res = Enrichers::IPInfo.query(ip)

        return nil if res.nil? || res.asn.nil?

        new(asn: res.asn)
      end
    end
  end
end
