require "date"
require "pathname"
require "yaml"
require "erb"

module Mihari
  module Mixins
    module Rule
      #
      # Load rule into hash
      #
      # @param [String] path Path to YAML file or YAML string
      #
      # @return [Hash]
      #
      def load_rule(path)
        return YAML.safe_load(File.read(path), permitted_classes: [Date], symbolize_names: true) if Pathname(path).exist?

        YAML.safe_load(path, symbolize_names: true)
      end

      #
      # Validate rule schema and return a normalized rule
      #
      # @param [Hash] rule
      #
      # @return [Hash]
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
          raise ArgumentError, "Invalid rule schema"
        end

        result.to_h
      end

      #
      # Returns a template for rule
      #
      # @return [String] A template for rule
      #
      def rule_template
        # Use ERB to fill created_on and updated_on with Date.today
        data = File.read(File.expand_path("../templates/rule.yml.erb", __dir__))
        template = ERB.new(data)
        data = template.result

        # validate the template of rule for just in case
        rule = YAML.safe_load(data, permitted_classes: [Date], symbolize_names: true)
        validate_rule rule

        data
      end

      #
      # Create (blank) rule file
      #
      # @param [String] filename
      # @param [Dry::Files] files
      # @param [String] template
      #
      # @return [nil]
      #
      def initialize_rule_yaml(filename, files = Dry::Files.new, template: rule_template)
        files.write(filename, template)
      end
    end
  end
end
