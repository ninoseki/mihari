# frozen_string_literal: true

require "normalize_country"

module Mihari
  module Models
    #
    # Geolocation model
    #
    class Geolocation < ActiveRecord::Base
      belongs_to :artifact

      class << self
        include Dry::Monads[:result]

        #
        # Build Geolocation
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::MMDB] enricher
        #
        # @return [Mihari::Geolocation, nil]
        #
        def build_by_ip(ip, enricher: Enrichers::MMDB.new)
          result = enricher.result(ip).bind do |res|
            value = res&.country_code
            if value.nil?
              Success nil
            else
              Success new(country: NormalizeCountry(value, to: :short), country_code: value)
            end
          end
          result.value_or nil
        end
      end
    end
  end
end
