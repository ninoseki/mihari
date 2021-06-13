# frozen_string_literal: true

require "colorize"

module Mihari
  module Commands
    module Config
      def self.included(thor)
        thor.class_eval do
          desc "init_config", "Create a YAML configuration file"
          method_option :filename, type: :string, default: "mihari.yml"
          def init_config
            filename = options["filename"]

            warning = "#{filename} exists. Do you want to overwrite it? (y/n)"
            if File.exist?(filename) && !(yes? warning)
              return
            end

            Mihari.initialize_config_yaml filename
            puts "The config file is initialized as #{filename}.".colorize(:blue)
          end
        end
      end
    end
  end
end
