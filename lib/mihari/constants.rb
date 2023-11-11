# frozen_string_literal: true

module Mihari
  # @return [Array<String>]
  DEFAULT_DATA_TYPES = Types::DataTypes.values.freeze

  # @return [Array<Hash>]
  DEFAULT_EMITTERS = Emitters::Database.class_keys.map { |name| { emitter: name.downcase } }.freeze

  # @return [Array<Hash>]
  DEFAULT_ENRICHERS = Mihari.enricher_to_class.keys.map { |name| { enricher: name.downcase } }.freeze
end
