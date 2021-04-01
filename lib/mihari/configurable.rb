# frozen_string_literal: true

module Mihari
  module Configurable
    def configured?
      config_keys.all? { |key| Mihari.config.send(key) }
    end

    def configuration_values
      return nil if config_keys.empty?

      config_keys.map do |key|
        {key: key.upcase, value: Mihari.config.send(key)}
      end
    end

    def config_keys
      []
    end
  end
end
