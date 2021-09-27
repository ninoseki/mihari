# frozen_string_literal: true

module Mihari
  module Entities
    class IPAddress < Grape::Entity
      expose :ip, documentation: { type: String, required: true }
      expose :country_code, documentation: { type: String, required: true }, as: :countryCode
      expose :hostname, documentation: { type: String, required: false }
      expose :loc, documentation: { type: String, required: true }
      expose :asn, documentation: { type: Integer, required: false }
    end
  end
end
