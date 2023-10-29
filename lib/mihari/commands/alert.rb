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

                run_proxy_l = ->(proxy) { run_proxy proxy }
                result = builder.result.bind(run_proxy_l)

                alert = result.value!
                data = Entities::Alert.represent(alert)
                puts JSON.pretty_generate(data.as_json)
              end
            end

            no_commands do
              #
              # @param [Mihari::Services::AlertProxy] proxy
              #
              def run_proxy(proxy)
                Dry::Monads::Try[StandardError] do
                  runner = Services::AlertRunner.new(proxy)
                  runner.run
                end.to_result
              end
            end
          end
        end
      end
    end
  end
end
