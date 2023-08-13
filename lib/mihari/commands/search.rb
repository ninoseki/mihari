# frozen_string_literal: true

module Mihari
  module Commands
    module Search
      class << self
        def included(thor)
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
                rule = Services::RuleProxy.from_path_or_id path_or_id

                begin
                  rule.validate!
                rescue RuleValidationError
                  return
                end

                force_overwrite = options["force_overwrite"] || false
                runner = Services::RuleRunner.new(rule, force_overwrite: force_overwrite)

                if runner.diff? && !force_overwrite
                  message = "There is diff in the rule (#{rule.id}). Are you sure you want to overwrite the rule? (y/n)"
                  return unless yes?(message)
                end

                runner.update_or_create

                begin
                  alert = runner.run
                rescue ConfigurationError => e
                  # if there is a configuration error, output that error without the stack trace
                  Mihari.logger.error e.to_s
                  return
                end

                if alert.nil?
                  Mihari.logger.info "There is no new artifact found"
                  return
                end

                data = Mihari::Entities::Alert.represent(alert)
                puts JSON.pretty_generate(data.as_json)
              end
            end
          end
        end
      end
    end
  end
end
