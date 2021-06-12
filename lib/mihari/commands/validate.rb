# frozen_string_literal: true

module Mihari
  module Commands
    module Validate
      include Mixins::Rule

      def self.included(thor)
        thor.class_eval do
          desc "validate [RULE]", "Validate format of a rule"
          def validate(rule)
            # convert str(YAML) to hash or str(path/YAML file) to hash
            rule = load_rule(rule)

            # validate rule schema
            validate_rule rule

            puts "Valid format. The input is parsed as the following:"
            puts rule
          end
        end
      end
    end
  end
end
