# frozen_string_literal: true

module Mihari
  module Entities
    class WhoisRecord < Grape::Entity
      expose :domain, documentation: { type: String, required: true }
      expose :created_on, documentation: { type: Date, required: false }, as: :createdOn
      expose :updated_on, documentation: { type: Date, required: false }, as: :updatedOn
      expose :expires_on, documentation: { type: Date, required: false }, as: :expiresOn
      expose :registrar, documentation: { type: Hash, required: false }
      expose :contacts, documentation: { type: Hash, is_array: true, required: true } do |whois_record, _options|
        whois_record.contacts.map(&:to_camelback_keys)
      end
      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt
    end
  end
end
