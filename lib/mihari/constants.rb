# frozen_string_literal: true

module Mihari
  ALLOWED_DATA_TYPES = ["hash", "ip", "domain", "url", "mail"].freeze

  DEFAULT_EMITTERS = ["database", "misp", "slack", "the_hive", "webhook"].map { |name| { emitter: name } }.freeze
end
