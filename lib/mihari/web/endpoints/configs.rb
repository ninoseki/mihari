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
          configs = (Mihari.analyzers + Mihari.emitters + Mihari.enrichers).map do |klass|
            Mihari::Structs::Config.from_class(klass)
          end.compact

          present(configs, with: Entities::Config)
        end
      end
    end
  end
end
