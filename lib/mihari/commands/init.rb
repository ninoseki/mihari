# frozen_string_literal: true

module Mihari
  module Commands
    module Initialization
      include Mixins::Rule

      def self.included(thor)
        thor.class_eval do
          desc "rule", "Create a rule file"
          method_option :filename, type: :string, default: "rule.yml"
          def rule
            filename = options["filename"]

            warning = "#{filename} exists. Do you want to overwrite it? (y/n)"
            if File.exist?(filename) && !(yes? warning)
              return
            end

            initialize_rule_yaml filename

            Mihari.logger.info "The rule file is initialized as #{filename}."
          end
        end
      end
    end
  end
end
