# frozen_string_literal: true

module Mihari
  module Mixins
    module Database
      def with_db_connection
        Mihari::Database.connect
        yield
      rescue ActiveRecord::StatementInvalid
        Mihari.logger.error("You haven't finished the DB migration! Please run 'mihari db migrate'.")
      ensure
        Mihari::Database.close
      end
    end
  end
end
