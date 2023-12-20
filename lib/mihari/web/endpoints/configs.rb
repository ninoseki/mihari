# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Config API endpoint
      #
      class Configs < Grape::API
        namespace :configs do
          desc "list configs", {
            is_array: true,
            success: Entities::Config,
            summary: "List configs"
          }
          get "/" do
            configs = Services::ConfigSearcher.call
            present(configs, with: Entities::Config)
          end
        end
      end
    end
  end
end
