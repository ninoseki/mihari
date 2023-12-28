require "sidekiq"

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

    class ArtifactEnrichJob
      include Sidekiq::Job

      #
      # @param [Integer] id
      #
      def perform(id)
        Mihari::Database.with_db_connection do
          Services::ArtifactEnricher.call id
        end
      end
    end
  end
end
