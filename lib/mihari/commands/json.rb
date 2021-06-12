# frozen_string_literal: true

module Mihari
  module Commands
    module JSON
      def self.included(thor)
        thor.class_eval do
          desc "import_from_json", "Give a JSON input via STDIN"
          def import_from_json(input = nil)
            with_error_handling do
              json = input || $stdin.gets.chomp
              raise ArgumentError, "Input not found: please give an input in a JSON format" unless json

              json = parse_as_json(json)
              raise ArgumentError, "Invalid input format: an input JSON data should have title, description and artifacts key" unless required_alert_keys?(json)

              title = json["title"]
              description = json["description"]
              artifacts = json["artifacts"]
              tags = json["tags"] || []

              basic = Analyzers::Basic.new(title: title, description: description, artifacts: artifacts, source: "json", tags: tags)

              basic.ignore_old_artifacts = options["ignore_old_artifacts"] || false
              basic.ignore_threshold = options["ignore_threshold"] || 0

              basic.run
            end
          end

          no_commands do
            def parse_as_json(input)
              ::JSON.parse input
            rescue ::JSON::ParserError => _e
              nil
            end
          end
        end
      end
    end
  end
end
