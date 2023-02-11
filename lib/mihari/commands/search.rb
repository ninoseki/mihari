# frozen_string_literal: true

module Mihari
  module Commands
    module Search
      include Mixins::Database
      include Mixins::ErrorNotification

      def self.included(thor)
        thor.class_eval do
          desc "search [RULE]", "Search by a rule"
          method_option :yes, type: :boolean, aliases: "-y", desc: "yes to overwrite the rule in the database"
          def search_by_rule(path_or_id)
            rule = Structs::Rule.from_path_or_id path_or_id

            # validate
            begin
              rule.validate!
            rescue RuleValidationError
              return
            end

            # check update
            yes = options["yes"] || false
            unless yes
              with_db_connection do
                next if Mihari::Rule.find(rule.id).yaml == rule.yaml
                unless yes?("This operation will overwrite the rule in the database (Rule ID: #{rule.id}). Are you sure you want to update the rule? (yes/no)")
                  return
                end
              rescue ActiveRecord::RecordNotFound
                next
              end
            end

            rule.to_model.save

            analyzer = rule.to_analyzer

            with_error_notification do
              alert = analyzer.run
              if alert
                data = Mihari::Entities::Alert.represent(alert)
                puts JSON.pretty_generate(data.as_json)
              else
                Mihari.logger.info "No new alert created in the database"
              end
            end
          end
        end
      end
    end
  end
end
