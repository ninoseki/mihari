# frozen_string_literal: true

module Mihari
  module Commands
    module Search
      class << self
        def included(thor)
          thor.class_eval do
            include Dry::Monads[:try, :result]

            desc "search [PATH_OR_ID]", "Search by a rule (Outputs null if there is no new finding)"
            method_option :force_overwrite, type: :boolean, aliases: "-f", desc: "Force overwriting a rule"
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

                result = builder.result.bind(check_diff_l).bind(update_and_run_l)

                alert = result.value!
                data = Entities::Alert.represent(alert)
                puts JSON.pretty_generate(data.as_json)
              end
            end

            no_commands do
              #
              # @param [Mihari::Services::RuleProxy] rule
              #
              def check_diff(rule)
                force_overwrite = options["force_overwrite"] || false
                message = "There is a diff in the rule. Are you sure you want to overwrite the rule? (y/n)"
                runner = Services::RuleRunner.new(rule)

                exit 0 if runner.diff? && !force_overwrite && !yes?(message)

                Success runner
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
