# frozen_string_literal: true

require "pathname"

module Mihari
  module Commands
    module Rule
      class << self
        def included(thor)
          thor.class_eval do
            include Dry::Monads[:try, :result]

            desc "validate [PATH]", "Validate a rule file"
            #
            # Validate format of a rule
            #
            # @param [String] path
            #
            def validate(path)
              res = Dry::Monads::Try[ValidationError] do
                Services::RuleProxy.from_yaml File.read(path)
              end

              rule = res.value!
              puts rule.data.to_yaml
            end

            desc "init [PATH]", "Initialize a new rule file"
            #
            # Initialize a new rule file
            #
            # @param [String] path
            #
            #
            def init(path = "./rule.yml")
              warning = "#{path} exists. Do you want to overwrite it? (y/n)"
              return if Pathname(path).exist? && !(yes? warning)

              initialize_rule path

              puts "A new rule file has been initialized: #{path}."
            end

            no_commands do
              #
              # @return [Mihari::Services::Rule]
              #
              def rule
                Services::RuleProxy.from_yaml File.read(File.expand_path("../templates/rule.yml.erb", __dir__))
              end

              #
              # Create a new rule
              #
              # @param [String] path
              # @param [Dry::Files] files
              #
              # @return [nil]
              #
              def initialize_rule(path, files = Dry::Files.new)
                files.write(path, rule.yaml)
              end
            end
          end
        end
      end
    end
  end
end
