# frozen_string_literal: true

module Mihari
  module Entities
    class Geolocation < Grape::Entity
      expose :country, documentation: { type: String, required: true }
      expose :country_code, documentation: { type: String, required: true }, as: :countryCode
    end
  end
end
