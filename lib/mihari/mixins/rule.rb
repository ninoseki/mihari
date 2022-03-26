# frozen_string_literal: true

require "date"
require "erb"
require "pathname"

module Mihari
  module Mixins
    module Rule
      include Mixins::Database

      def load_erb_yaml(yaml)
        YAML.safe_load(ERB.new(yaml).result, permitted_classes: [Date], symbolize_names: true)
      end

      #
      # Load rule into hash
      #
      # @param [String] path_or_id Path to YAML file or YAML string or ID of a rule in the database
      #
      # @return [Mihari::Structs::Rule::Rule]
      #
      def load_rule(path_or_id)
        yaml = nil

        yaml = load_yaml_from_file(path_or_id) if File.exist?(path_or_id)
        yaml = load_yaml_from_db(path_or_id) if yaml.nil?

        Structs::Rule::Rule.from_yaml yaml
      end

      def load_yaml_from_file(path)
        return nil unless Pathname(path).exist?

        File.read path
      end

      def load_yaml_from_db(id)
        with_db_connection do
          rule = Mihari::Rule.find(id)
          rule.yaml || rule.symbolized_data.to_yaml
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
      rescue RuleValidationError => e
        Mihari.logger.error "Failed to parse the input as a rule"
        raise e
      end

      #
      # Returns a template for rule
      #
      # @return [String] A template for rule
      #
      def rule_template
        yaml = File.read(File.expand_path("../templates/rule.yml.erb", __dir__))
        Structs::Rule::Rule.from_yaml yaml
        yaml
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
