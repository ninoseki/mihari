# frozen_string_literal: true

module Mihari
  module Models
    #
    # CPE model
    #
    class CPE < ActiveRecord::Base
      belongs_to :artifact

      class << self
        #
        # Build CPEs
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::Shodan] enricher
        #
        # @return [Array<Mihari::CPE>]
        #
        def build_by_ip(ip, enricher: Enrichers::Shodan.new)
          enricher.result(ip).fmap do |res|
            (res&.cpes || []).map { |cpe| new(cpe: cpe) }
          end.value_or []
        end
      end
    end
  end
end
