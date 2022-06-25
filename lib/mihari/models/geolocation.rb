# frozen_string_literal: true

require "normalize_country"

module Mihari
  class Geolocation < ActiveRecord::Base
    belongs_to :artifact

    class << self
      #
      # Build Geolocation
      #
      # @param [String] ip
      #
      # @return [Mihari::Geolocation, nil]
      #
      def build_by_ip(ip)
        res = Enrichers::IPInfo.query(ip)

        return nil if res&.country_code.nil?

        new(country: NormalizeCountry(res.country_code, to: :short), country_code: res.country_code)
      end
    end
  end
end
