# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Database sub-commands
    #
    module Database
      class << self
        def included(thor)
          thor.class_eval do
            include Mixins

            desc "migrate", "Migrate DB schemas"
            around :with_db_connection
            method_option :verbose, type: :boolean, default: true
            #
            # @param [String] direction
            #
            def migrate(direction = "up")
              ActiveRecord::Migration.verbose = options["verbose"]
              Mihari::Database.migrate direction.to_sym
            end
          end
        end
      end
    end
  end
end
