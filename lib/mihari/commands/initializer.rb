# frozen_string_literal: true

require "pathname"

module Mihari
  module Commands
    module Initializer
      def self.included(thor)
        thor.class_eval do
          desc "init", "Initialize a new rule"
          method_option :path, type: :string, default: "./rule.yml"
          def init
            path = options["path"]

            warning = "#{path} exists. Do you want to overwrite it? (y/n)"
            return if Pathname(path).exist? && !(yes? warning)

            initialize_rule_yaml path

            Mihari.logger.info "A new rule is initialized as #{path}."
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
            def initialize_rule_yaml(path, files = Dry::Files.new)
              files.write(path, rule_template.yaml)
            end
          end
        end
      end
    end
  end
end
