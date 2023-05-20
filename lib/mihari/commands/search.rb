# frozen_string_literal: true

module Mihari
  module Commands
    module Search
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
            Mihari::Database.with_db_connection do
              rule = Structs::Rule.from_path_or_id path_or_id

              begin
                rule.validate!
              rescue RuleValidationError
                return
              end

              update_rule rule
              run_rule rule
            end
          end
        end
      end

      # @param [Mihari::Structs::Rule] rule
      #
      def update_rule(rule)
        force_overwrite = options["force_overwrite"] || false
        begin
          rule_model = Mihari::Rule.find(rule.id)
          has_change = rule_model.data != rule.data.deep_stringify_keys
          has_change_and_not_force_overwrite = has_change & !force_overwrite

          confirm_message = "This operation will overwrite the rule in the database (Rule ID: #{rule.id}). Are you sure you want to update the rule? (y/n)"
          return if has_change_and_not_force_overwrite && !yes?(confirm_message)
          # update the rule
          rule.model.save
        rescue ActiveRecord::RecordNotFound
          # create a new rule
          rule.model.save
        end
      end

      #
      # @param [Mihari::Structs::Rule] rule
      #
      def run_rule(rule)
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
