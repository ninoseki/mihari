# frozen_string_literal: true

module Mihari
  module Endpoints
    class Configs < Grape::API
      namespace :configs do
        desc "Get configs", {
          is_array: true,
          success: Entities::Config
        }
        get "/" do
          statuses = Status.check

          configs = statuses.map do |key, value|
            { name: key, status: value }
          end
          present(configs, with: Entities::Config)
        end
      end
    end
  end
end
