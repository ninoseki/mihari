# frozen_string_literal: true

module Mihari
  module Commands
    module Searcher
      include Mixins::Database
      include Mixins::ErrorNotification

      def self.included(thor)
        thor.class_eval do
          desc "search [PATH]", "Search by a rule"
          method_option :force_overwrite, type: :boolean, aliases: "-f", desc: "Force an overwrite the rule"
          #
          # Search by a rule
          #
          # @param [String] path_or_id
          #
          def search(path_or_id)
            with_db_connection do
              rule = Structs::Rule.from_path_or_id path_or_id

              # validate
              begin
                rule.validate!
              rescue RuleValidationError
                return
              end

              force_overwrite = options["force_overwrite"] || false

              begin
                rule_model = Mihari::Rule.find(rule.id)
                has_change = rule_model.data != rule.data.deep_stringify_keys
                has_change_and_not_force_overwrite = has_change & !force_overwrite

                if has_change_and_not_force_overwrite && !yes?("This operation will overwrite the rule in the database (Rule ID: #{rule.id}). Are you sure you want to update the rule? (y/n)")
                  return
                end

                # update the rule
                rule.model.save
              rescue ActiveRecord::RecordNotFound
                # create a new rule
                rule.model.save
              end

              with_error_notification do
                alert = rule.analyzer.run
                if alert
                  data = Mihari::Entities::Alert.represent(alert)
                  puts JSON.pretty_generate(data.as_json)
                else
                  Mihari.logger.info "There is no new alert created in the database"
                end
              end
            end
          end
        end
      end
    end
  end
end
