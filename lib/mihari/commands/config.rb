module Mihari
  module Commands
    module Config
      def self.included(thor)
        thor.class_eval do
          desc "init_config", "Create a config file"
          method_option :filename, type: :string, default: "mihari.yml"
          def init_config
            filename = options["filename"]

            if File.exist?(filename) && !(yes? "#{filename} exists. Do you want to overwrite it? (y/n)")
              return
            end

            Mihari::Config.initialize_yaml filename
          end
        end
      end
    end
  end
end
