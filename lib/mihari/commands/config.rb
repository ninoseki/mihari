# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Config sub-commands
    #
    module Config
      class << self
        def included(thor)
          thor.class_eval do
            desc "list", "List configs"
            def list
              configs = Services::ConfigSearcher.call
              data = configs.map { |config| Entities::Config.represent(config) }
              puts JSON.pretty_generate(data.as_json)
            end
          end
        end
      end
    end
  end
end
