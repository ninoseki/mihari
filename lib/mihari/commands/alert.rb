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
                proxy = Mihari::Services::AlertProxy.from_path(path)
                proxy.validate!

                runner = Mihari::Services::AlertRunner.new(proxy)

                begin
                  alert = runner.run
                rescue ActiveRecord::RecordNotFound => e
                  # if there is a ActiveRecord::RecordNotFound, output that error without the stack trace
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
