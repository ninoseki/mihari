# frozen_string_literal: true

module Mihari
  module Models
    class CPE < ActiveRecord::Base
      belongs_to :artifact

      class << self
        include Dry::Monads[:result]

        #
        # Build CPEs
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::Shodan] enricher
        #
        # @return [Array<Mihari::CPE>]
        #
        def build_by_ip(ip, enricher: Enrichers::Shodan.new)
          result = enricher.query_result(ip).bind do |res|
            if res.nil?
              Success []
            else
              Success(res.cpes.map { |cpe| new(cpe: cpe) })
            end
          end
          result.value_or []
        end
      end
    end
  end
end
