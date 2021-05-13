# frozen_string_literal: true

require "dry/configurable"
require "dry/files"
require "mem"
require "yaml"

def truthy?(value)
  return true if value == "true"
  return true if value == true

  false
end

module Mihari
  extend Dry::Configurable

  setting :binaryedge_api_key, ENV["BINARYEDGE_API_KEY"]
  setting :censys_id, ENV["CENSYS_ID"]
  setting :censys_secret, ENV["CENSYS_SECRET"]
  setting :circl_passive_password, ENV["CIRCL_PASSIVE_PASSWORD"]
  setting :circl_passive_username, ENV["CIRCL_PASSIVE_USERNAME"]
  setting :misp_api_endpoint, ENV["MISP_API_ENDPOINT"]
  setting :misp_api_key, ENV["MISP_API_KEY"]
  setting :onyphe_api_key, ENV["ONYPHE_API_KEY"]
  setting :otx_api_key, ENV["OTX_API_KEY"]
  setting :passivetotal_api_key,  ENV["PASSIVETOTAL_API_KEY"]
  setting :passivetotal_username, ENV["PASSIVETOTAL_USERNAME"]
  setting :pulsedive_api_key, ENV["PULSEDIVE_API_KEY"]
  setting :securitytrails_api_key, ENV["SECURITYTRAILS_API_KEY"]
  setting :shodan_api_key, ENV["SHODAN_API_KEY"]
  setting :slack_channel, ENV["SLACK_CHANNEL"]
  setting :slack_webhook_url, ENV["SLACK_WEBHOOK_URL"]
  setting :spyse_api_key, ENV["SPYSE_API_KEY"]
  setting :thehive_api_endpoint, ENV["THEHIVE_API_ENDPOINT"]
  setting :thehive_api_key, ENV["THEHIVE_API_KEY"]
  setting :urlscan_api_key, ENV["URLSCAN_API_KEY"]
  setting :virustotal_api_key, ENV["VIRUSTOTAL_API_KEY"]
  setting :zoomeye_api_key, ENV["ZOOMEYE_API_KEY"]
  setting :webhook_url, ENV["WEBHOOK_URL"]
  setting(:webhook_use_json_body, ENV["WEBHOOK_USE_JSON_BODY"]) { |value| truthy?(value) }
  setting :database, ENV["DATABASE"] || "mihari.db"

  class << self
    include Mem

    def emitters
      []
    end
    memoize :emitters

    def analyzers
      []
    end
    memoize :analyzers

    def load_config_from_yaml(path)
      raise ArgumentError, "#{path} does not exist." unless File.exist?(path)

      data = File.read(path)
      begin
        yaml = YAML.safe_load(data)
      rescue TypeError => _e
        return
      end

      yaml.each do |key, value|
        Mihari.config.send("#{key.downcase}=".to_sym, value)
      end
    end

    def initialize_config_yaml(filename, files = Dry::Files.new)
      config = Mihari.config.values.keys.map do |key|
        [key.to_s, nil]
      end.to_h

      files.write(filename, YAML.dump(config))
    end
  end
end

require "mihari/version"
require "mihari/errors"

require "mihari/database"
require "mihari/type_checker"

require "mihari/models/alert"
require "mihari/models/artifact"
require "mihari/models/tag"
require "mihari/models/tagging"

require "mihari/serializers/alert"
require "mihari/serializers/artifact"
require "mihari/serializers/tag"

require "mihari/html"

require "mihari/configurable"
require "mihari/retriable"

require "mihari/analyzers/base"
require "mihari/analyzers/basic"

require "mihari/analyzers/binaryedge"
require "mihari/analyzers/censys"
require "mihari/analyzers/circl"
require "mihari/analyzers/crtsh"
require "mihari/analyzers/dnpedia"
require "mihari/analyzers/dnstwister"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/otx"
require "mihari/analyzers/passivetotal"
require "mihari/analyzers/pulsedive"
require "mihari/analyzers/securitytrails_domain_feed"
require "mihari/analyzers/securitytrails"
require "mihari/analyzers/shodan"
require "mihari/analyzers/spyse"
require "mihari/analyzers/urlscan"
require "mihari/analyzers/virustotal"
require "mihari/analyzers/zoomeye"

require "mihari/analyzers/free_text"
require "mihari/analyzers/http_hash"
require "mihari/analyzers/passive_dns"
require "mihari/analyzers/passive_ssl"
require "mihari/analyzers/reverse_whois"
require "mihari/analyzers/ssh_fingerprint"

require "mihari/notifiers/base"
require "mihari/notifiers/slack"
require "mihari/notifiers/exception_notifier"

require "mihari/emitters/base"
require "mihari/emitters/database"
require "mihari/emitters/misp"
require "mihari/emitters/slack"
require "mihari/emitters/stdout"
require "mihari/emitters/the_hive"
require "mihari/emitters/webhook"

require "mihari/status"

require "mihari/web/app"

require "mihari/cli"
