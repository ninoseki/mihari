# frozen_string_literal: true

require "date"
require "erb"
require "pathname"

module Mihari
  module Mixins
    module Rule
      include Mixins::Database

      #
      # Load rule into hash
      #
      # @param [String] path_or_id Path to YAML file or YAML string or ID of a rule in the database
      #
      # @return [Mihari::Structs::Rule::Rule]
      #
      def load_rule(path_or_id)
        data = nil

        data = load_data_from_file(path_or_id) if File.exist?(path_or_id)
        data = load_data_from_db(path_or_id) if data.nil?

        Structs::Rule::Rule.new(data)
      end

      def load_data_from_file(path)
        return YAML.safe_load(File.read(path), permitted_classes: [Date], symbolize_names: true) if Pathname(path).exist?

        YAML.safe_load(path, symbolize_names: true)
      end

      def load_data_from_db(id)
        with_db_connection do
          rule = Mihari::Rule.find(id)
          rule.data
        rescue ActiveRecord::RecordNotFound
          raise ArgumentError, "ID:#{id} is not found in the database"
        end
      end

      #
      # Validate a rule
      #
      # @param [Mihari::Structs::Rule::Rule] rule
      #
      def validate_rule!(rule)
        rule.validate!

        puts "Valid format. The input is parsed as the following:"
        puts rule.data.to_yaml
      rescue RuleValidationError => e
        error_message = "Failed to parse the input as a rule:\n#{e.message}"
        puts error_message.colorize(:red)
        raise e
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
        hashed_data = YAML.safe_load(data, permitted_classes: [Date], symbolize_names: true)
        Structs::Rule::Rule.new(hashed_data)

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
