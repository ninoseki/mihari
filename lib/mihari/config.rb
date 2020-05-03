# frozen_string_literal: true

require "yaml"

module Mihari
  class Config
    attr_accessor :binaryedge_api_key
    attr_accessor :censys_id
    attr_accessor :censys_secret
    attr_accessor :circl_passive_password
    attr_accessor :circl_passive_username
    attr_accessor :misp_api_endpoint
    attr_accessor :misp_api_key
    attr_accessor :onyphe_api_key
    attr_accessor :passivetotal_api_key
    attr_accessor :passivetotal_username
    attr_accessor :pulsedive_api_key
    attr_accessor :securitytrails_api_key
    attr_accessor :shodan_api_key
    attr_accessor :slack_channel
    attr_accessor :slack_webhook_url
    attr_accessor :thehive_api_endpoint
    attr_accessor :thehive_api_key
    attr_accessor :virustotal_api_key
    attr_accessor :zoomeye_password
    attr_accessor :zoomeye_username

    attr_accessor :database

    def initialize
      load_from_env
    end

    def load_from_env
      @binaryedge_api_key = ENV["BINARYEDGE_API_KEY"]
      @censys_id = ENV["CENSYS_ID"]
      @censys_secret = ENV["CENSYS_SECRET"]
      @circl_passive_password = ENV["CIRCL_PASSIVE_PASSWORD"]
      @circl_passive_username = ENV["CIRCL_PASSIVE_USERNAME"]
      @misp_api_endpoint = ENV["MISP_API_ENDPOINT"]
      @misp_api_key = ENV["MISP_API_KEY"]
      @onyphe_api_key = ENV["ONYPHE_API_KEY"]
      @passivetotal_api_key = ENV["PASSIVETOTAL_API_KEY"]
      @passivetotal_username = ENV["PASSIVETOTAL_USERNAME"]
      @pulsedive_api_key = ENV["PULSEDIVE_API_KEY"]
      @securitytrails_api_key = ENV["SECURITYTRAILS_API_KEY"]
      @shodan_api_key = ENV["SHODAN_API_KEY"]
      @slack_channel = ENV["SLACK_CHANNEL"]
      @slack_webhook_url = ENV["SLACK_WEBHOOK_URL"]
      @thehive_api_endpoint = ENV["THEHIVE_API_ENDPOINT"]
      @thehive_api_key = ENV["THEHIVE_API_KEY"]
      @virustotal_api_key = ENV["VIRUSTOTAL_API_KEY"]
      @zoomeye_password = ENV["ZOOMEYE_PASSWORD"]
      @zoomeye_username = ENV["ZOOMEYE_USERNAME"]

      @database = ENV["DATABASE"] || "mihari.db"
    end

    class << self
      def load_from_yaml(path)
        raise ArgumentError, "#{path} does not exist." unless File.exist?(path)

        data = File.read(path)
        begin
          yaml = YAML.safe_load(data)
        rescue TypeError => _e
          return
        end

        Mihari.configure do |config|
          yaml.each do |key, value|
            config.send("#{key.downcase}=".to_sym, value)
          end
        end
      end
    end
  end

  class << self
    def config
      @config ||= Config.new
    end

    attr_writer :config

    def configure
      yield config
    end
  end
end
