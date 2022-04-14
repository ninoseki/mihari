# frozen_string_literal: true

module Mihari
  class CPE < ActiveRecord::Base
    belongs_to :artifact

    class << self
      #
      # Build CPEs
      #
      # @param [String] ip
      #
      # @return [Array<Mihari::CPE>]
      #
      def build_by_ip(ip)
        res = Enrichers::Shodan.query(ip)
        return if res.nil?

        res.cpes.map { |cpe| new(cpe: cpe) }
      end
    end
  end
end
