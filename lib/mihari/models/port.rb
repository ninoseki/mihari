# frozen_string_literal: true

module Mihari
  module Models
    #
    # Port model
    #
    class Port < ActiveRecord::Base
      belongs_to :artifact

      class << self
        #
        # Build ports
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::Shodan] enricher
        #
        # @return [Array<Mihari::Port>]
        #
        def build_by_ip(ip, enricher: Enrichers::Shodan.new)
          enricher.result(ip).fmap do |res|
            res.nil? ? [] : res.ports.map { |port| new(port: port) }
          end.value_or []
        end
      end
    end
  end
end
