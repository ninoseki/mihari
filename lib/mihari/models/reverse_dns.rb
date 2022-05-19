# frozen_string_literal: true

module Mihari
  class ReverseDnsName < ActiveRecord::Base
    belongs_to :artifact

    class << self
      #
      # Build reverse DNS names
      #
      # @param [String] ip
      #
      # @return [Array<Mihari::ReverseDnsName>]
      #
      def build_by_ip(ip)
        res = Enrichers::Shodan.query(ip)
        return [] if res.nil?

        res.hostnames.map { |name| new(name: name) }
      end
    end
  end
end
