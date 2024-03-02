# frozen_string_literal: true

# standard libs
require "date"
require "erb"
require "ipaddr"
require "json"
require "pathname"
require "resolv"
require "securerandom"
require "yaml"

# Active Support & Active Record
require "active_support"
require "active_record"

# Search Cop
require "search_cop"

# dry-rb
require "dry/files"
require "dry/monads"
require "dry/schema"
require "dry/struct"
require "dry/types"
require "dry/validation"

# Grape
require "grape"
require "grape-entity"

# Other utility libs
require "addressable/uri"
require "awrence"
require "email_address"
require "memo_wise"
require "parallel"
require "plissken"
require "public_suffix"
require "semantic_logger"
require "sentry-ruby"
require "uuidtools"

# Load .env
require "dotenv/load"

# Mihari
require "mihari/version"
require "mihari/errors"

require "mihari/config"

# Concerns
require "mihari/concerns/autonomous_system_normalizable"
require "mihari/concerns/configurable"
require "mihari/concerns/database_connectable"
require "mihari/concerns/error_unwrappable"
require "mihari/concerns/falsepositive_normalizable"
require "mihari/concerns/falsepositive_validatable"
require "mihari/concerns/refangable"
require "mihari/concerns/retriable"

#
# Mihari module
#
module Mihari
  class << self
    prepend MemoWise

    #
    # @return [Array<Mihari::Emitters::Base>]
    #
    def emitters
      []
    end
    memo_wise :emitters

    #
    # @return [Hash{String => Mihari::Enrichers::Base}]
    #
    def emitter_to_class
      @emitter_to_class ||= emitters.flat_map do |klass|
        klass.keys.map { |key| [key, klass] }
      end.to_h
    end

    #
    # @return [Array<Mihari::Analyzers::Base>]
    #
    def analyzers
      []
    end
    memo_wise :analyzers

    #
    # @return [Hash{String => Mihari::Analyzers::Base}]
    #
    def analyzer_to_class
      @analyzer_to_class ||= analyzers.flat_map do |klass|
        klass.keys.map { |key| [key, klass] }
      end.to_h
    end

    #
    # @return [Array<Mihari::Enrichers::Base>]
    #
    def enrichers
      []
    end
    memo_wise :enrichers

    #
    # @return [Hash{String => Mihari::Enrichers::Base}]
    #
    def enricher_to_class
      @enricher_to_class ||= enrichers.flat_map do |klass|
        klass.keys.map { |key| [key, klass] }
      end.to_h
    end

    #
    # @return [Mihari::Config]
    #
    def config
      @config ||= Config.new
    end

    def logger
      SemanticLogger.sync! unless puma?

      SemanticLogger.default_level = :info
      SemanticLogger.add_appender(io: $stderr, formatter: :color)
      SemanticLogger["Mihari"]
    end
    memo_wise :logger

    #
    # @return [String]
    #
    def env
      ENV["APP_ENV"] || ENV["RACK_ENV"]
    end

    #
    # @return [Boolean]
    #
    def development?
      env == "development"
    end

    #
    # @return [Boolean]
    #
    def sidekiq?
      !Mihari.config.sidekiq_redis_url.nil?
    end

    #
    # @return [Boolean]
    #
    def puma?
      !Puma.stats.nil?
    rescue
      false
    end

    def initialize_sentry
      return if Mihari.config.sentry_dsn.nil?
      return if Sentry.initialized?

      Sentry.init do |config|
        config.dsn = Mihari.config.sentry_dsn
        config.traces_sample_rate = Mihari.config.sentry_trace_sample_rate
        config.breadcrumbs_logger = %i[sentry_logger http_logger]
      end
    end
  end
end

# Core classes
require "mihari/service"

require "mihari/actor"

require "mihari/database"
require "mihari/http"
require "mihari/data_type"
require "mihari/rule"

# Enrichers
require "mihari/enrichers/base"
require "mihari/enrichers/google_public_dns"
require "mihari/enrichers/mmdb"
require "mihari/enrichers/shodan"
require "mihari/enrichers/whois"

# Models
require "mihari/models/concerns/searchable"

require "mihari/models/alert"
require "mihari/models/artifact"
require "mihari/models/autonomous_system"
require "mihari/models/cpe"
require "mihari/models/dns"
require "mihari/models/geolocation"
require "mihari/models/port"
require "mihari/models/reverse_dns"
require "mihari/models/rule"
require "mihari/models/tag"
require "mihari/models/tagging"
require "mihari/models/vulnerability"
require "mihari/models/whois"

# Emitters
require "mihari/emitters/base"

require "mihari/emitters/database"
require "mihari/emitters/misp"
require "mihari/emitters/slack"
require "mihari/emitters/the_hive"
require "mihari/emitters/webhook"

# Clients
require "mihari/clients/base"

require "mihari/clients/binaryedge"
require "mihari/clients/censys"
require "mihari/clients/circl"
require "mihari/clients/crtsh"
require "mihari/clients/dnstwister"
require "mihari/clients/fofa"
require "mihari/clients/google_public_dns"
require "mihari/clients/greynoise"
require "mihari/clients/hunterhow"
require "mihari/clients/misp"
require "mihari/clients/mmdb"
require "mihari/clients/onyphe"
require "mihari/clients/otx"
require "mihari/clients/passivetotal"
require "mihari/clients/publsedive"
require "mihari/clients/securitytrails"
require "mihari/clients/shodan_internet_db"
require "mihari/clients/shodan"
require "mihari/clients/the_hive"
require "mihari/clients/urlscan"
require "mihari/clients/virustotal"
require "mihari/clients/whois"
require "mihari/clients/zoomeye"

# Analyzers
require "mihari/analyzers/base"

require "mihari/analyzers/binaryedge"
require "mihari/analyzers/censys"
require "mihari/analyzers/circl"
require "mihari/analyzers/crtsh"
require "mihari/analyzers/dnstwister"
require "mihari/analyzers/feed"
require "mihari/analyzers/fofa"
require "mihari/analyzers/greynoise"
require "mihari/analyzers/hunterhow"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/otx"
require "mihari/analyzers/passivetotal"
require "mihari/analyzers/pulsedive"
require "mihari/analyzers/securitytrails"
require "mihari/analyzers/shodan"
require "mihari/analyzers/urlscan"
require "mihari/analyzers/virustotal_intelligence"
require "mihari/analyzers/virustotal"
require "mihari/analyzers/zoomeye"

# Types
require "mihari/types"

# Constants
require "mihari/constants"

# Structs
require "mihari/structs/binaryedge"
require "mihari/structs/censys"
require "mihari/structs/config"
require "mihari/structs/filters"
require "mihari/structs/fofa"
require "mihari/structs/google_public_dns"
require "mihari/structs/greynoise"
require "mihari/structs/hunterhow"
require "mihari/structs/mmdb"
require "mihari/structs/onyphe"
require "mihari/structs/shodan"
require "mihari/structs/urlscan"
require "mihari/structs/virustotal_intelligence"

# Schemas
require "mihari/schemas/macros"
require "mihari/schemas/concerns/orrable"

require "mihari/schemas/options"

require "mihari/schemas/alert"
require "mihari/schemas/analyzer"
require "mihari/schemas/rule"

# Services
require "mihari/services/builders"
require "mihari/services/creators"
require "mihari/services/destroyers"
require "mihari/services/enrichers"
require "mihari/services/feed"
require "mihari/services/getters"
require "mihari/services/initializers"
require "mihari/services/proxies"
require "mihari/services/renderer"
require "mihari/services/searchers"

# Entities
require "mihari/entities/pagination"

require "mihari/entities/autonomous_system"
require "mihari/entities/config"
require "mihari/entities/cpe"
require "mihari/entities/dns"
require "mihari/entities/geolocation"
require "mihari/entities/ip_address"
require "mihari/entities/messages"
require "mihari/entities/port"
require "mihari/entities/reverse_dns"
require "mihari/entities/tag"
require "mihari/entities/vulnerability"
require "mihari/entities/whois"

require "mihari/entities/artifact"

require "mihari/entities/alert"

require "mihari/entities/rule"

# Initialize Sentry (if it's possible)
Mihari.initialize_sentry
