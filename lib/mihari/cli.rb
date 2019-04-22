# frozen_string_literal: true

require "thor"
require "json"

module Mihari
  class CLI < Thor
    desc "censys [QUERY]", "Censys lookup by a given query"
    def censys(query)
      with_error_handling do
        censys = Analyzers::Censys.new(query)
        censys.run
      end
    end

    desc "import_from_json", "Give a JSON input via STDIN"
    def import_from_json(input = nil)
      json = input || STDIN.gets.chomp
      raise ArgumentError, "Input not found: please give an input in a JSON format" unless json

      json = parse_as_json(json)
      raise ArgumentError, "Invalid input format: an input JSON data should have title, description and artifacts key" unless valid_json?(json)

      title = json.dig("title")
      description = json.dig("description")
      artifacts = json.dig("artifacts")

      with_error_handling do
        basic = Analyzers::Basic.new(title: title, description: description, artifacts: artifacts)
        basic.run
      end
    end

    no_commands do
      def with_error_handling
        yield
      rescue ArgumentError, Hachi::Error => e
        puts "Warning: #{e}"
      rescue StandardError => e
        puts "Warning: #{e}"
        puts e.backtrace.join('\n')
      end

      def parse_as_json(input)
        JSON.parse input
      rescue JSON::ParserError => _
        nil
      end

      # @return [true, false]
      def valid_json?(json)
        %w(title description artifacts).all? { |key| json.key? key }
      end
    end
  end
end
