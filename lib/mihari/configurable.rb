# frozen_string_literal: true

module Mihari
  class Configurable
    def valid?
      keys.all? { |key| ENV.key? key }
    end

    def configuration_status
      return nil if keys.empty?

      names = keys.join(" and ")
      be_verb = keys.length == 1 ? "is" : "are"
      status = valid? ? "found" : "missing"
      "#{names} #{be_verb} #{status}"
    end

    private

    def keys
      []
    end
  end
end
