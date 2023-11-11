# frozen_string_literal: true

module Mihari
  module Commands
    module Mixins
      def with_db_connection(&block)
        Mihari::Database.with_db_connection(&block)
      end
    end
  end
end
