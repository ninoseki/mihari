# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Alert sub-commands
    #
    module Alert
      class << self
        def included(thor)
          thor.class_eval do
            include Dry::Monads[:result, :try]

            desc "add [PATH]", "Add an alert"
            #
            # @param [String] path
            #
            def add(path)
              Mihari::Database.with_db_connection do
                result = Dry::Monads::Try[StandardError] do
                  # @type [Mihari::Services::AlertProxy]
                  proxy = Mihari::Services::AlertBuilder.call(path)
                  Mihari::Services::AlertRunner.call(proxy)
                end.to_result

                # @type [Mihari::Models::Alert]
                alert = result.value!
                data = Entities::Alert.represent(alert)
                puts JSON.pretty_generate(data.as_json)
              end
            end
          end
        end
      end
    end
  end
end
