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
                builder = Services::RuleBuilder.new(path_or_id)

                build_result = builder.result
                if build_result.failure?
                  failure = build_result.failure

                  raise failure unless failure.is_a?(ValidationError)

                  Mihari.logger.error "Failed to parse the input as a rule:"
                  Mihari.logger.error JSON.pretty_generate(failure.errors.to_h)
                  return
                end
                rule = build_result.value!

                force_overwrite = options["force_overwrite"] || false
                runner = Services::RuleRunner.new(rule, force_overwrite: force_overwrite)

                if runner.diff? && !force_overwrite
                  message = "There is diff in the rule (#{rule.id}). Are you sure you want to overwrite the rule? (y/n)"
                  return unless yes?(message)
                end

                runner.update_or_create

                run_result = runner.result
                if run_result.failure?
                  failure = run_result.failure
                  Mihari.logger.error failure
                  Sentry.capture_exception(failure) if Sentry.initialized?
                  return
                end

                alert = run_result.value!
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
