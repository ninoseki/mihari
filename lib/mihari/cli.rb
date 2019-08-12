# frozen_string_literal: true

require "thor"
require "json"

module Mihari
  class CLI < Thor
    desc "censys [QUERY]", "Censys IPv4 lookup by a given query"
    method_option :tags, type: :array, desc: "tags"
    def censys(query)
      tags = options.dig("tags") || []
      censys = Analyzers::Censys.new(query, tags: tags)
      run_analyzer censys
    end

    desc "shodan [QUERY]", "Shodan host lookup by a given query"
    method_option :tags, type: :array, desc: "tags"
    def shodan(query)
      tags = options.dig("tags") || []
      shodan = Analyzers::Shodan.new(query, tags: tags)
      run_analyzer shodan
    end

    desc "onyphe [QUERY]", "Onyphe datascan lookup by a given query"
    method_option :tags, type: :array, desc: "tags"
    def onyphe(query)
      tags = options.dig("tags") || []
      onyphe = Analyzers::Onyphe.new(query, tags: tags)
      run_analyzer onyphe
    end

    desc "urlscan [QUERY]", "urlscan lookup by a given query"
    method_option :tags, type: :array, desc: "tags"
    def urlscan(query)
      tags = options.dig("tags") || []
      urlscan = Analyzers::Urlscan.new(query, tags: tags)
      run_analyzer urlscan
    end

    desc "virustotal [IP|DOMAIN]", "VirusTotal resolutions lookup by a given ip or domain"
    method_option :tags, type: :array, desc: "tags"
    def virustotal(indiactor)
      tags = options.dig("tags") || []
      virustotal = Analyzers::VirusTotal.new(indiactor, tags: tags)
      run_analyzer virustotal
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
      tags = json.dig("tags") || []

      basic = Analyzers::Basic.new(title: title, description: description, artifacts: artifacts, tags: tags)
      run_analyzer basic
    end

    desc "alerts", "Show the alerts on TheHive"
    method_option :limit, default: 5, desc: "Number of alerts to show (or 'all' to show all the alerts)"
    def alerts
      with_error_handling do
        viewer = AlertViewer.new(limit: options["limit"])
        alerts = viewer.list
        puts JSON.pretty_generate(alerts)
      end
    end

    no_commands do
      def with_error_handling
        yield
      rescue ArgumentError, Hachi::Error, Censys::ResponseError, Error => e
        puts "Warning: #{e}"
      rescue StandardError => e
        puts "Warning: #{e}"
        puts e.backtrace.join('\n')
      end

      def run_analyzer(analyzer)
        with_error_handling { analyzer.run }
      end

      def parse_as_json(input)
        JSON.parse input
      rescue JSON::ParserError => e
        nil
      end

      # @return [true, false]
      def valid_json?(json)
        %w(title description artifacts).all? { |key| json.key? key }
      end
    end
  end
end
