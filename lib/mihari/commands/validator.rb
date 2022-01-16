# frozen_string_literal: true

module Mihari
  module Commands
    module Validator
      include Mixins::Rule

      def self.included(thor)
        thor.class_eval do
          desc "rule [PATH]", "Validate format of a rule file"
          def rule(path)
            rule = load_rule(path)

            begin
              rule.validate!

              puts "Valid format. The input is parsed as the following:"
              puts rule.data.to_yaml
            rescue RuleValidationError => e
              error_message = "Failed to parse the input as a rule!"
              puts error_message.colorize(:red)
              puts e.message
            end
          end
        end
      end
    end
  end
end
