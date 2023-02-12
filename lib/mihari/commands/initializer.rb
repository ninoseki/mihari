# frozen_string_literal: true

module Mihari
  module Commands
    module Initializer
      def self.included(thor)
        thor.class_eval do
          desc "init", "Initialize a new rule"
          method_option :filename, type: :string, default: "rule.yml"
          def init
            filename = options["filename"]

            warning = "#{filename} exists. Do you want to overwrite it? (y/n)"
            return if File.exist?(filename) && !(yes? warning)

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
            # Create a (blank) rule file
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
