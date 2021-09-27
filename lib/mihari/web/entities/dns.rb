# frozen_string_literal: true

module Mihari
  module Entities
    class DnsRecord < Grape::Entity
      expose :resource, documentation: { type: String, required: true }
      expose :value, documentation: { type: String, required: true }
    end
  end
end
