# frozen_string_literal: true

module Mihari
  module Configurable
    #
    # Check whether it is configured or not
    #
    # @return [Boolean]
    #
    def configured?
      configuration_keys.all? { |key| Mihari.config.send(key) }
    end

    #
    # Configuration values
    #
    # @return [Array<Hash>, nil] Configuration values as a list of hash. Returns nil if there is any keys.
    #
    def configuration_values
      return nil if configuration_keys.empty?

      configuration_keys.map do |key|
        { key: key.upcase, value: Mihari.config.send(key) }
      end
    end

    #
    # Configuration keys
    #
    # @return [Array<String>] A list of cofiguration keys
    #
    def configuration_keys
      []
    end
  end
end
