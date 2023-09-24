# frozen_string_literal: true

module Mihari
  module Commands
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
                builder = Mihari::Services::AlertBuilder.new(path)

                run_proxy_l = ->(proxy) { run_proxy proxy }
                check_nil_l = ->(alert_or_nil) { check_nil alert_or_nil }

                result = builder.result.bind(run_proxy_l).bind(check_nil_l)

                if result.success?
                  alert = result.value!
                  data = Mihari::Entities::Alert.represent(alert)
                  puts JSON.pretty_generate(data.as_json)
                  return
                end

                failure = result.failure
                case failure
                when ValidationError
                  Mihari.logger.error "Failed to parse the input as an alert:"
                  Mihari.logger.error JSON.pretty_generate(failure.errors.to_h)
                when StandardError
                  raise failure
                else
                  Mihari.logger.info failure
                end
              end
            end

            no_commands do
              #
              # @param [Mihari::Services::AlertProxy] proxy
              #
              def run_proxy(proxy)
                Dry::Monads::Try[StandardError] do
                  runner = Mihari::Services::AlertRunner.new(proxy)
                  runner.run
                end.to_result
              end

              #
              # @param [Mihari::Alert, nil] alert_or_nil
              #
              def check_nil(alert_or_nil)
                if alert_or_nil.nil?
                  Failure "There is no new artifact found"
                else
                  Success alert_or_nil
                end
              end
            end
          end
        end
      end
    end
  end
end
