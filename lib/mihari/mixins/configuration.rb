# frozen_string_literal: true

require "colorize"
require "yaml"

module Mihari
  module Mixins
    module Configuration
      #
      # Load config file into hash
      #
      # @param [String] path Path to YAML file
      #
      # @return [Hash]
      #
      def load_config(path)
        data = _load_config(path)
        data.transform_keys(&:downcase)
      end

      #
      # Validate config schema
      #
      # @param [Hash] config
      #
      def validate_config(config)
        error_message = "Failed to parse the input as a config!"

        contract = Schemas::ConfigurationContract.new
        result = contract.call(config)
        unless result.errors.empty?
          puts error_message.colorize(:red)
          show_validation_errors result.errors
          raise ArgumentError, "Invalid config schema"
        end

        # check keys
        # TODO: check keys with dry-schema
        valid_keys = Mihari.config.values.keys
        config.each_key do |key|
          unless valid_keys.include?(key)
            puts error_message.colorize(:red)
            raise ArgumentError, "#{key} is not a valid key."
          end
        end
      end

      #
      # Returns a template for config
      #
      # @return [String] A template for config
      #
      def config_template
        config = Mihari.config.values.keys.to_h do |key|
          [key.to_s, nil]
        end

        YAML.dump(config)
      end

      #
      # Create (blank) config file
      #
      # @param [String] filename
      # @param [Dry::Files] files
      # @param [String] template
      #
      # @return [nil]
      #
      def initialize_config_yaml(filename, files = Dry::Files.new, template: config_template)
        files.write(filename, template)
      end

      private

      def show_validation_errors(errors)
        errors.messages.each do |message|
          path = message.path.map(&:to_s).join
          puts "- #{path} #{message.text}".colorize(:red)
        end
      end

      #
      # Load configuration file
      #
      # @param [String] path
      #
      # @return [Hash]
      #
      def _load_config(path)
        unless Pathname(path).exist?
          puts "#{path} does not exist".colorize(:red)
          raise FileNotFoundError
        end

        YAML.safe_load(File.read(path), symbolize_names: true)
      end
    end
  end
end
