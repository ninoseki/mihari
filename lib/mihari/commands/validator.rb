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
              validate_rule! rule
            rescue RuleValidationError
              nil
            end
          end
        end
      end
    end
  end
end
