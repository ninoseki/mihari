# frozen_string_literal: true

require "active_record"

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

        unless res.nil?
          return new(asn: res.asn)
        end

        nil
      end
    end
  end
end
