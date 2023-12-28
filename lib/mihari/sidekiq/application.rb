require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { url: Mihari.config.redis_url.to_s }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Mihari.config.redis_url.to_s }
end

module Mihari
  module Jobs
    class SearchJob
      include Sidekiq::Job

      #
      # @param [String] path_or_id
      #
      def perform(path_or_id)
        Mihari::Database.with_db_connection do
          rule = Mihari::Rule.from_model(Mihari::Models::Rule.find(path_or_id))
          rule.call
        end
      end
    end
  end
end
