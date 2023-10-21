# frozen_string_literal: true

module Mihari
  class Port < ActiveRecord::Base
    belongs_to :artifact

    class << self
      include Dry::Monads[:result]

      #
      # Build ports
      #
      # @param [String] ip
      # @param [Mihari::Enrichers::Shodan] enricher
      #
      # @return [Array<Mihari::Port>]
      #
      def build_by_ip(ip, enricher: Enrichers::Shodan.new)
        result = enricher.query_result(ip).bind do |res|
          if res.nil?
            Success []
          else
            Success(res.ports.map { |port| new(port: port) })
          end
        end
        result.value_or []
      end
    end
  end
end
