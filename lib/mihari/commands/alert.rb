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
                builder = Services::AlertBuilder.new(path)

                runner_result_l = ->(proxy) { Services::AlertRunner.new(proxy).result }
                result = builder.result.bind(runner_result_l)

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
