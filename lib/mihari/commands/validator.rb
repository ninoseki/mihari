# frozen_string_literal: true

module Mihari
  module Commands
    module Validator
      include Mixins::Rule
      include Mixins::Configuration

      def self.included(thor)
        thor.class_eval do
          desc "rule [PATH]", "Validate format of a rule file"
          def rule(path)
            # convert str(YAML) to hash or str(path/YAML file) to hash
            rule = load_rule(path)

            # validate rule schema
            validate_rule rule

            puts "Valid format. The input is parsed as the following:"
            puts rule.to_yaml
          end

          desc "config [PATH]", "Validate format of a config file"
          def config(path)
            # convert str(YAML) to hash or str(path/YAML file) to hash
            config = load_config(path)

            # validate config schema
            validate_config config

            puts "Valid format. The input is parsed as the following:"
            puts config.to_yaml
          end
        end
      end
    end
  end
end
