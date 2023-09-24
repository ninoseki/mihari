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
          configs = (Mihari.analyzers + Mihari.emitters + Mihari.enrichers).filter_map do |klass|
            Mihari::Structs::Config.from_class(klass)
          end

          present(configs, with: Entities::Config)
        end
      end
    end
  end
end
