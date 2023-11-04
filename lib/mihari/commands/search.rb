# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Search sub-commands
    #
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
                result = Dry::Monads::Try[StandardError] do
                  # @type [Mihari::Rule]
                  rule = Services::RuleBuilder.call(path_or_id)

                  force_overwrite = options["force_overwrite"] || false
                  message = "There is a diff in the rule. Are you sure you want to overwrite the rule? (y/n)"
                  exit 0 if rule.diff? && !force_overwrite && !yes?(message)

                  rule.update_or_create
                  rule.call
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
