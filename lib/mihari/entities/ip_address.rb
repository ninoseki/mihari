# frozen_string_literal: true

module Mihari
  module Entities
    class IPAddress < Grape::Entity
      expose :country_code, documentation: {type: String, required: true}, as: :countryCode
      expose :asn, documentation: {type: Integer, required: false}
      expose :loc, documentation: {type: String, required: false}
    end
  end
end
