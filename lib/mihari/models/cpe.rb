# frozen_string_literal: true

require "dry/monads"

module Mihari
  class CPE < ActiveRecord::Base
    belongs_to :artifact

    class << self
      include Dry::Monads[:result]

      #
      # Build CPEs
      #
      # @param [String] ip
      #
      # @return [Array<Mihari::CPE>]
      #
      def build_by_ip(ip)
        result = Enrichers::Shodan.query_result(ip).bind do |res|
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
