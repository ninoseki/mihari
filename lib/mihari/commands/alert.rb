# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Alert sub-commands
    #
    module Alert
      class << self
        def included(thor)
          thor.class_eval do
            include Dry::Monads[:result, :try]
            include Mixins

            desc "add [PATH]", "Add an alert"
            around :with_db_connection
            #
            # @param [String] path
            #
            def add(path)
              result = Dry::Monads::Try[StandardError] do
                # @type [Mihari::Services::AlertProxy]
                proxy = Mihari::Services::AlertBuilder.call(path)
                Mihari::Services::AlertRunner.call proxy
              end.to_result

              # @type [Mihari::Models::Alert]
              alert = result.value!
              data = Entities::Alert.represent(alert)
              puts JSON.pretty_generate(data.as_json)
            end

            desc "search", "Search alerts"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def search(q = "")
              filter = Structs::Filters::Search.new(q: q, page: options["page"], limit: options["limit"])
              result = Services::AlertSearcher.result(filter)
              value = result.value!
              data = Entities::AlertsWithPagination.represent(
                alerts: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end
          end
        end
      end
    end
  end
end
