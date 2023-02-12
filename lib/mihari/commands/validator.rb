# frozen_string_literal: true

module Mihari
  module Commands
    module Validator
      def self.included(thor)
        thor.class_eval do
          desc "validate [PATH]", "Validate a rule file"
          #
          # Validate format of a rule
          #
          # @param [String] path
          #
          # @return [nil]
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
        end
      end
    end
  end
end
