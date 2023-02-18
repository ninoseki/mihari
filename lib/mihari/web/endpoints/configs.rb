# frozen_string_literal: true

module Mihari
  module Endpoints
    class Configs < Grape::API
      namespace :configs do
        desc "Get configs", {
          is_array: true,
          success: Entities::Config,
          summary: "Get configs"
        }
        get "/" do
          present(Mihari.configs, with: Entities::Config)
        end
      end
    end
  end
end
