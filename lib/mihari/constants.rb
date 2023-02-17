# frozen_string_literal: true

module Mihari
  DEFAULT_DATA_TYPES = %w[hash ip domain url mail].freeze

  DEFAULT_EMITTERS = %w[database misp slack the_hive].map { |name| { emitter: name } }.freeze

  DEFAULT_ENRICHERS = %w[whois ipinfo shodan google_public_dns].map { |name| { enricher: name } }.freeze
end
