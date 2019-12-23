# frozen_string_literal: true

require "thor"
require "json"

module Mihari
  class CLI < Thor
    class_option :config, type: :string, desc: "path to config file"

    desc "censys [QUERY]", "Censys IPv4 search by a query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    method_option :type, type: :string, desc: "type to search (ipv4 / websites / certificates)", default: "ipv4"
    def censys(query)
      with_error_handling do
        run_analyzer Analyzers::Censys, query: query, options: options
      end
    end

    desc "shodan [QUERY]", "Shodan host search by a query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def shodan(query)
      with_error_handling do
        run_analyzer Analyzers::Shodan, query: query, options: options
      end
    end

    desc "onyphe [QUERY]", "Onyphe datascan search by a query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def onyphe(query)
      with_error_handling do
        run_analyzer Analyzers::Onyphe, query: query, options: options
      end
    end

    desc "urlscan [QUERY]", "urlscan search by a given query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    method_option :target_type, type: :string, default: "url", desc: "target type to fetch from lookup results (target type should be 'url', 'domain' or 'ip')"
    def urlscan(query)
      with_error_handling do
        run_analyzer Analyzers::Urlscan, query: query, options: options
      end
    end

    desc "virustotal [IP|DOMAIN]", "VirusTotal resolutions lookup by an ip or domain"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def virustotal(indiactor)
      with_error_handling do
        run_analyzer Analyzers::VirusTotal, query: refang(indiactor), options: options
      end
    end

    desc "securitytrails [IP|DOMAIN|EMAIL]", "SecurityTrails lookup by an ip, domain or email"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def securitytrails(indiactor)
      with_error_handling do
        run_analyzer Analyzers::SecurityTrails, query: refang(indiactor), options: options
      end
    end
    map "st" => :securitytrails

    desc "securitytrails_domain_feed [REGEXP]", "SecurityTrails new domain feed search by a regexp"
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

    desc "crtsh [QUERY]", "crt.sh search by a query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def crtsh(query)
      with_error_handling do
        run_analyzer Analyzers::Crtsh, query: query, options: options
      end
    end

    desc "dnpedia [QUERY]", "DNPedia domain search by a query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def dnpedia(query)
      with_error_handling do
        run_analyzer Analyzers::DNPedia, query: query, options: options
      end
    end

    desc "circl [DOMAIN|SHA1]", "CIRCL passive DNS/SSL lookup by a domain or SHA1 certificate fingerprint"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def circl(query)
      with_error_handling do
        run_analyzer Analyzers::CIRCL, query: refang(query), options: options
      end
    end

    desc "passivetotal [IP|DOMAIN|EMAIL|SHA1]", "PassiveTotal lookup by an ip, domain, email or SHA1 certificate fingerprint"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def passivetotal(indicator)
      with_error_handling do
        run_analyzer Analyzers::PassiveTotal, query: refang(indicator), options: options
      end
    end

    desc "zoomeye [QUERY]", "ZoomEye search by a query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    method_option :type, type: :string, desc: "type to search(host / web)", default: "host"
    def zoomeye(query)
      with_error_handling do
        run_analyzer Analyzers::ZoomEye, query: query, options: options
      end
    end

    desc "binaryedge [QUERY]", "BinaryEdge host search by a query"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def binaryedge(query)
      with_error_handling do
        run_analyzer Analyzers::BinaryEdge, query: query, options: options
      end
    end

    desc "pulsedive [IP|DOMAIN]", "Pulsedive lookup by an ip or domain"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def pulsedive(indiactor)
      with_error_handling do
        run_analyzer Analyzers::Pulsedive, query: refang(indiactor), options: options
      end
    end

    desc "dnstwister [DOMAIN]", "dnstwister lookup by a domain"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def dnstwister(domain)
      with_error_handling do
        run_analyzer Analyzers::DNSTwister, query: refang(domain), options: options
      end
    end

    desc "passive_dns [IP|DOMAIN]", "Cross search with passive DNS services by an ip or domain"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def passive_dns(query)
      with_error_handling do
        run_analyzer Analyzers::PassiveDNS, query: refang(query), options: options
      end
    end

    desc "passive_ssl [SHA1]", "Cross search with passive SSL services by an SHA1 certificate fingerprint"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def passive_ssl(query)
      with_error_handling do
        run_analyzer Analyzers::PassiveSSL, query: query, options: options
      end
    end

    desc "reverse_whois [EMAIL]", "Cross search with reverse whois services by an email"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def reverse_whois(query)
      with_error_handling do
        run_analyzer Analyzers::ReveseWhois, query: refang(query), options: options
      end
    end

    desc "http_hash", "Cross search with search engines by a hash of an HTTP response (SHA256, MD5 and MurmurHash3)"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    method_option :md5, type: :string, desc: "MD5 hash"
    method_option :sha256, type: :string, desc: "SHA256 hash"
    method_option :mmh3, type: :numeric, desc: "MurmurHash3 hash"
    method_option :html, type: :string, desc: "path to an HTML file"
    def http_hash
      with_error_handling do
        run_analyzer Analyzers::HTTPHash, query: nil, options: options
      end
    end

    desc "free_text [TEXT]", "Cross search with search engines by a free text"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def free_text(text)
      with_error_handling do
        run_analyzer Analyzers::FreeText, query: text, options: options
      end
    end

    desc "ssh_fingerprint [FINGERPRINT]", "Cross search with search engines by an SSH fingerprint (e.g. dc:14:de:8e:d7:c1:15:43:23:82:25:81:d2:59:e8:c0)"
    method_option :title, type: :string, desc: "title"
    method_option :description, type: :string, desc: "description"
    method_option :tags, type: :array, desc: "tags"
    def ssh_fingerprint(fingerprint)
      with_error_handling do
        run_analyzer Analyzers::SSHFingerprint, query: fingerprint, options: options
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
        load_configuration
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

      def load_configuration
        config = options["config"]
        Config.load_from_yaml(config) if config
      end

      def run_analyzer(analyzer_class, query:, options:)
        load_configuration

        options = symbolize_hash_keys(options)
        options = normalize_options(options)

        analyzer = analyzer_class.new(query, **options)
        analyzer.run
      end

      def symbolize_hash_keys(hash)
        hash.map { |k, v| [k.to_sym, v] }.to_h
      end

      def normalize_options(options)
        # Delete :config because it is not intended to use for running an analyzer
        options.delete(:config)
        options
      end

      def refang(indicator)
        indicator.gsub("[.]", ".").gsub("(.)", ".")
      end
    end
  end
end
