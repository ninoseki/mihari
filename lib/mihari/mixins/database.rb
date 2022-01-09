# frozen_string_literal: true

module Mihari
  module Mixins
    module Database
      def with_db_connection
        Mihari::Database.connect
        yield
      ensure
        Mihari::Database.close
      end
    end
  end
end
