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
            include Mixins

            desc "add [PATH]", "Add an alert"
            around :with_db_connection
            #
            # @param [String] path
            #
            def add(path)
              result = Dry::Monads::Try[StandardError] do
                # @type [Mihari::Services::AlertProxy]
                proxy = Mihari::Services::AlertBuilder.call(path)
                Mihari::Services::AlertRunner.call proxy
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
