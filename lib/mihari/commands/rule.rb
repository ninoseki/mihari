# frozen_string_literal: true

require "pathname"

module Mihari
  module Commands
    module Rule
      def self.included(thor)
        thor.class_eval do
          desc "validate [PATH]", "Validate a rule file"
          #
          # Validate format of a rule
          #
          # @param [String] path
          #
          def validate(path)
            rule = Structs::Rule.from_path_or_id(path)

            begin
              rule.validate!
              Mihari.logger.info "Valid format. The input is parsed as the following:"
              Mihari.logger.info rule.data.to_yaml
            rescue RuleValidationError
              nil
            end
          end

          desc "init [PATH]", "Initialize a new rule file"
          #
          # Initialize a new rule file
          #
          # @param [String] path
          #
          #
          def init(path = "./rule.yml")
            warning = "#{path} exists. Do you want to overwrite it? (y/n)"
            return if Pathname(path).exist? && !(yes? warning)

            initialize_rule path

            Mihari.logger.info "A new rule is initialized: #{path}."
          end

          no_commands do
            #
            # @return [Mihari::Structs::Rule]
            #
            def rule_template
              Structs::Rule.from_path File.expand_path("../templates/rule.yml.erb", __dir__)
            end

            #
            # Create a new rule
            #
            # @param [String] path
            # @param [Dry::Files] files
            #
            # @return [nil]
            #
            def initialize_rule(path, files = Dry::Files.new)
              files.write(path, rule_template.yaml)
            end
          end
        end
      end
    end
  end
end
