# frozen_string_literal: true

module Mihari
  module Commands
    module Alert
      class << self
        def included(thor)
          thor.class_eval do
            desc "add [PATH]", "Add an alert"
            #
            # @param [String] path
            #
            def add(path)
              Mihari::Database.with_db_connection do
                builder = Mihari::Services::AlertBuilder.new(path)

                build_result = builder.result
                if build_result.failure?
                  failure = build_result.failure

                  raise failure unless failure.is_a?(ValidationError)

                  Mihari.logger.error "Failed to parse the input as an alert:"
                  Mihari.logger.error JSON.pretty_generate(failure.errors.to_h)
                  return
                end

                proxy = builder.result.value!

                runner = Mihari::Services::AlertRunner.new(proxy)

                run_result = runner.result

                if run_result.failure?
                  begin
                    raise run_result.failure
                  rescue ActiveRecord::RecordNotFound => e
                    # if there is a ActiveRecord::RecordNotFound, output that error without the stack trace
                    Mihari.logger.error e.to_s
                    return
                  end
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
