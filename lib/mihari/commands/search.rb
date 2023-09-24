# frozen_string_literal: true

module Mihari
  module Commands
    module Search
      class << self
        def included(thor)
          thor.class_eval do
            include Dry::Monads[:result, :try]

            desc "search [PATH_OR_ID]", "Search by a rule"
            method_option :force_overwrite, type: :boolean, aliases: "-f", desc: "Force an overwrite the rule"
            #
            # Search by a rule
            #
            # @param [String] path_or_id
            #
            def search(path_or_id)
              Mihari::Database.with_db_connection do
                builder = Services::RuleBuilder.new(path_or_id)

                check_diff_l = ->(rule) { check_diff rule }
                update_and_run_l = ->(runner) { update_and_run runner }
                check_nil_l = ->(alert_or_nil) { check_nil alert_or_nil }

                result = builder.result.bind(check_diff_l).bind(update_and_run_l).bind(check_nil_l)

                if result.success?
                  alert = result.value!
                  data = Mihari::Entities::Alert.represent(alert)
                  puts JSON.pretty_generate(data.as_json)
                  return
                end

                failure = result.failure
                case failure
                when ValidationError
                  Mihari.logger.error "Failed to parse the input as a rule:"
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
              # @param [Mihari::Services::RuleProxy] rule
              #
              def check_diff(rule)
                force_overwrite = options["force_overwrite"] || false
                runner = Services::RuleRunner.new(rule, force_overwrite: force_overwrite)
                message = "There is a diff in the rule (#{rule.id}). Are you sure you want to overwrite the rule? (y/n)"

                if runner.diff? && !force_overwrite && !yes?(message)
                  return Failure("Stop overwriting the rule (#{rule.id})")
                end

                Success runner
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

              #
              # @param [Mihari::Services::RuleRunner] runner
              #
              def update_and_run(runner)
                Dry::Monads::Try[StandardError] do
                  runner.update_or_create
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
