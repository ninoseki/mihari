# frozen_string_literal: true

module Mihari
  module Commands
    module Search
      include Mixins::Database
      include Mixins::Rule
      include Mixins::ErrorNotification

      def self.included(thor)
        thor.class_eval do
          desc "search [RULE]", "Search by a rule"
          def search_by_rule(path_or_id)
            rule = load_rule(path_or_id)

            # validate
            begin
              validate_rule! rule
            rescue RuleValidationError => e
              raise e
            end

            analyzer = rule.to_analyzer

            with_error_notification do
              alert = analyzer.run

              if alert
                data = Mihari::Entities::Alert.represent(alert)
                puts JSON.pretty_generate(data.as_json)
              else
                Mihari.logger.info "There is no new artifact"
              end

              # record a rule
              with_db_connection do
                model = rule.to_model
                model.save
              rescue ActiveRecord::RecordNotUnique
                nil
              end
            end
          end
        end
      end
    end
  end
end
