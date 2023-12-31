# frozen_string_literal: true

require "sidekiq"

module Mihari
  module Jobs
    class SearchJob
      include Sidekiq::Job
      include Concerns::DatabaseConnectable

      #
      # @param [String] path_or_id
      #
      def perform(path_or_id)
        with_db_connection do
          rule = Mihari::Rule.from_model(Mihari::Models::Rule.find(path_or_id))
          rule.call
        end
      end
    end

    class ArtifactEnrichJob
      include Sidekiq::Job
      include Concerns::DatabaseConnectable

      #
      # @param [Integer] id
      #
      def perform(id)
        with_db_connection do
          Services::ArtifactEnricher.call id
        end
      end
    end
  end
end
