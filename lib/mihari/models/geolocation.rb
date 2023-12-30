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
        #
        # Build Geolocation
        #
        # @param [String] ip
        # @param [Mihari::Enrichers::MMDB] enricher
        #
        # @return [Mihari::Geolocation, nil]
        #
        def build_by_ip(ip, enricher: Enrichers::MMDB.new)
          enricher.result(ip).fmap do |res|
            value = res&.country_code
            value.nil? ? nil : new(country: NormalizeCountry(value, to: :short), country_code: value)
          end.value_or nil
        end
      end
    end
  end
end
