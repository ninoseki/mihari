# frozen_string_literal: true

require "thor"
require "json"

module Mihari
  class CLI < Thor
    desc "censys [QUERY]", "Censys IPv4 lookup by a given query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def censys(query)
      with_error_handling do
        run_analyzer Analyzers::Censys, query: query, options: options
      end
    end

    desc "shodan [QUERY]", "Shodan host lookup by a given query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def shodan(query)
      with_error_handling do
        run_analyzer Analyzers::Shodan, query: query, options: options
      end
    end

    desc "onyphe [QUERY]", "Onyphe datascan lookup by a given query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def onyphe(query)
      with_error_handling do
        run_analyzer Analyzers::Onyphe, query: query, options: options
      end
    end

    desc "urlscan [QUERY]", "urlscan lookup by a given query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    method_option :target_type, type: :string, default: "url", desc: "target type to fetch from lookup results (target type should be 'url', 'domain' or 'ip')"
    def urlscan(query)
      with_error_handling do
        run_analyzer Analyzers::Urlscan, query: query, options: options
      end
    end

    desc "virustotal [IP|DOMAIN]", "VirusTotal resolutions lookup by a given ip or domain"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def virustotal(indiactor)
      with_error_handling do
        run_analyzer Analyzers::VirusTotal, query: indiactor, options: options
      end
    end

    desc "securitytrails [IP|DOMAIN]", "SecurityTrails resolutions lookup by a given ip or domain"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def securitytrails(indiactor)
      with_error_handling do
        run_analyzer Analyzers::SecurityTrails, query: indiactor, options: options
      end
    end
    map "st" => :securitytrails

    desc "securitytrails_domain_feed [REGEXP]", "SecurityTrails new domain feed lookup by a given regexp"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    method_option :type, type: :string, default: "registered", desc: "A type of domain feed ('all', 'new' or 'registered')"
    def securitytrails_domain_feed(regexp)
      with_error_handling do
        run_analyzer Analyzers::SecurityTrailsDomainFeed, query: regexp, options: options
      end
    end
    map "st_domain_feed" => :securitytrails_domain_feed

    desc "crtsh [QUERY]", "crt.sh lookup by a given query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def crtsh(query)
      with_error_handling do
        run_analyzer Analyzers::Crtsh, query: query, options: options
      end
    end

    desc "import_from_json", "Give a JSON input via STDIN"
    def import_from_json(input = nil)
      with_error_handling do
        json = input || STDIN.gets.chomp
        raise ArgumentError, "Input not found: please give an input in a JSON format" unless json

        json = parse_as_json(json)
        raise ArgumentError, "Invalid input format: an input JSON data should have title, description and artifacts key" unless valid_json?(json)

        title = json.dig("title")
        description = json.dig("description")
        artifacts = json.dig("artifacts")
        tags = json.dig("tags") || []

        basic = Analyzers::Basic.new(title: title, description: description, artifacts: artifacts, tags: tags)
        basic.run
      end
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

    desc "status", "Show the current configuration status"
    def status
      with_error_handling do
        puts JSON.pretty_generate(Status.check)
      end
    end

    no_commands do
      def with_error_handling
        yield
      rescue StandardError => e
        notifier = Notifiers::ExceptionNotifier.new
        notifier.notify e
      end

      def parse_as_json(input)
        JSON.parse input
      rescue JSON::ParserError => _e
        nil
      end

      # @return [true, false]
      def valid_json?(json)
        %w(title description artifacts).all? { |key| json.key? key }
      end

      def run_analyzer(analyzer_class, query:, options:)
        options = symbolize_hash_keys(options)

        analyzer = analyzer_class.new(query, **options)
        analyzer.run
      end

      def symbolize_hash_keys(hash)
        hash.map{ |k, v| [k.to_sym, v] }.to_h
      end
    end
  end
end
