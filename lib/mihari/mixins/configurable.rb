# frozen_string_literal: true

module Mihari
  module Mixins
    module Configurable
      #
      # Check whether there are configuration key-values or not
      #
      # @return [Boolean]
      #
      def configuration_keys?
        return true if configuration_keys.empty?

        configuration_keys.all? { |key| Mihari.config.send(key) }
      end

      #
      # Check whether it is configured or not
      #
      # @return [Boolean]
      #
      def configured?
        configuration_keys? || api_key?
      end

      #
      # Configuration values
      #
      # @return [Array<Hash>, nil] Configuration values as a list of hash. Returns nil if there is any keys.
      #
      def configuration_values
        return nil if configuration_keys.empty?

        configuration_keys.map do |key|
          value = Mihari.config.send(key)
          value = "REDACTED" if value && Mihari.config.hide_config_values
          { key: key.upcase, value: value }
        end
      end

      #
      # Configuration keys
      #
      # @return [Array<String>] A list of configuration keys
      #
      def configuration_keys
        []
      end

      private

      #
      # Check whether API key is set or not
      #
      # @return [Boolean]
      #
      def api_key?
        value = method(:api_key).call
        !value.nil?
      rescue NameError
        true
      end
    end
  end
end
