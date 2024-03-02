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
            success: Entities::Configs,
            summary: "List configs"
          }
          get "/" do
            configs = Services::ConfigSearcher.call
            present(
              {
                results: configs
              },
              with: Entities::Configs
            )
          end
        end
      end
    end
  end
end
