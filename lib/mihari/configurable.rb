# frozen_string_literal: true

module Mihari
  module Configurable
    def configured?
      config_keys.all? { |key| Mihari.config.send(key) }
    end

    def configuration_status
      return nil if config_keys.empty?

      names = config_keys.join(" and ")
      be_verb = config_keys.length == 1 ? "is" : "are"
      status = configured? ? "found" : "missing"
      "#{names} #{be_verb} #{status}"
    end

    def config_keys
      []
    end
  end
end
