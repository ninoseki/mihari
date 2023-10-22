# frozen_string_literal: true

module Mihari
  # @return [Array<String>]
  DEFAULT_DATA_TYPES = Types::DataTypes.values

  # TODO: make "database" the only default emitter
  # @return [Array<Hash>]
  DEFAULT_EMITTERS = %w[database misp slack thehive].map { |name| { emitter: name } }.freeze

  # @return [Array<Hash>]
  DEFAULT_ENRICHERS = Mihari.enricher_to_class.keys.map { |name| { enricher: name.downcase } }.freeze
end
