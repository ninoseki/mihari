# frozen_string_literal: true

module Mihari
  # @return [Array<String>]
  DEFAULT_DATA_TYPES = %w[hash ip domain url mail].freeze

  # @return [Array<Hash>]
  DEFAULT_EMITTERS = %w[database misp slack the_hive].map { |name| { emitter: name } }.freeze

  # @return [Array<Hash>]
  DEFAULT_ENRICHERS = %w[whois ipinfo shodan google_public_dns].map { |name| { enricher: name } }.freeze

  DEFAULT_RETRY_TIMES = 3
  DEFAULT_RETRY_INTERVAL = 5
end
