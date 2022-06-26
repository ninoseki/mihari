# frozen_string_literal: true

module Mihari
  module Commands
    module Initialization
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

          no_commands do
            #
            # Returns a template for rule
            #
            # @return [String] A template for rule
            #
            def rule_template
              rule = Structs::Rule.from_path_or_id File.expand_path("../templates/rule.yml.erb", __dir__)
              rule.yaml
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
    end
  end
end
