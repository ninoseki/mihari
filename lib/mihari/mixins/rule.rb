require "yaml"
require "pathname"

module Mihari
  module Mixins
    module Rule
      #
      # Load rule into hash
      #
      # @param [String] rule path to YAML file or YAML string
      #
      # @return [Hash]
      #
      def load_rule(rule)
        return YAML.safe_load(File.read(rule), symbolize_names: true) if Pathname(rule).exist?

        YAML.safe_load(rule, symbolize_names: true)
      end

      #
      # Validate rule schema
      #
      # @param [Hash] rule
      #
      def validate_rule(rule)
        error_message = "Failed to parse the input as a rule!"

        contract = Schemas::RuleContract.new
        begin
          result = contract.call(rule)
          unless result.errors.empty?
            messages = result.errors.messages.map do |message|
              path = message.path.map(&:to_s).join
              "#{path} #{message.text}"
            end
            puts error_message.colorize(:red)
            raise ArgumentError, messages.join("\n")
          end
        rescue NoMethodError
          puts error_message.colorize(:red)
          raise ArgumentError, "Failed to parse YAML file"
        end
      end
    end
  end
end
