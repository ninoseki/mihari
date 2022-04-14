# frozen_string_literal: true

module Mihari
  class Port < ActiveRecord::Base
    belongs_to :artifact

    class << self
      #
      # Build ports
      #
      # @param [String] ip
      #
      # @return [Array<Mihari::Port>]
      #
      def build_by_ip(ip)
        res = Enrichers::Shodan.query(ip)
        return if res.nil?

        res.ports.map { |port| new(port: port) }
      end
    end
  end
end
