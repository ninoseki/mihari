# frozen_string_literal: true

require "colorize"

module Mihari
  module Commands
    module Initialization
      include Mixins::Configuration
      include Mixins::Rule

      def self.included(thor)
        thor.class_eval do
          desc "config", "Create a config file"
          method_option :filename, type: :string, default: "mihari.yml"
          def config
            filename = options["filename"]

            warning = "#{filename} exists. Do you want to overwrite it? (y/n)"
            if File.exist?(filename) && !(yes? warning)
              return
            end

            initialize_config_yaml filename

            puts "The config file is initialized as #{filename}.".colorize(:blue)
          end

          desc "rule", "Create a rule file"
          method_option :filename, type: :string, default: "rule.yml"
          def rule
            filename = options["filename"]

            warning = "#{filename} exists. Do you want to overwrite it? (y/n)"
            if File.exist?(filename) && !(yes? warning)
              return
            end

            initialize_rule_yaml filename

            puts "The rule file is created as #{filename}.".colorize(:blue)
          end
        end
      end
    end
  end
end
