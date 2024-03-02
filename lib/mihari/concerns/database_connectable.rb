# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # Database connectable concern
    #
    module DatabaseConnectable
      extend ActiveSupport::Concern

      def with_db_connection(&)
        Database.with_db_connection(&)
      end
    end
  end
end
