# frozen_string_literal: true

module Mihari
  module Models
    #
    # Reverse DNS name model
    #
    class ReverseDnsName < ActiveRecord::Base
      belongs_to :artifact

      class << self
        include Dry::Monads[:result]

        #
        # Build reverse DNS names
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::Shodan] enricher
        #
        # @return [Array<Mihari::Models::ReverseDnsName>]
        #
        def build_by_ip(ip, enricher: Enrichers::Shodan.new)
          enricher.result(ip).fmap do |res|
            (res&.hostnames || []).map { |name| new(name: name) }
          end.value_or []
        end
      end
    end
  end
end
