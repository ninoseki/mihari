# frozen_string_literal: true

require "yaml"

module Mihari
  class Config
    attr_accessor :binaryedge_api_key, :censys_id, :censys_secret, :circl_passive_password, :circl_passive_username, :misp_api_endpoint, :misp_api_key, :onyphe_api_key, :otx_api_key, :passivetotal_api_key, :passivetotal_username, :pulsedive_api_key, :securitytrails_api_key, :shodan_api_key, :slack_channel, :slack_webhook_url, :spyse_api_key, :thehive_api_endpoint, :thehive_api_key, :urlscan_api_key, :virustotal_api_key, :zoomeye_api_key, :database

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
      @otx_api_key = ENV["OTX_API_KEY"]
      @passivetotal_api_key = ENV["PASSIVETOTAL_API_KEY"]
      @passivetotal_username = ENV["PASSIVETOTAL_USERNAME"]
      @pulsedive_api_key = ENV["PULSEDIVE_API_KEY"]
      @securitytrails_api_key = ENV["SECURITYTRAILS_API_KEY"]
      @shodan_api_key = ENV["SHODAN_API_KEY"]
      @slack_channel = ENV["SLACK_CHANNEL"]
      @slack_webhook_url = ENV["SLACK_WEBHOOK_URL"]
      @spyse_api_key = ENV["SPYSE_API_KEY"]
      @thehive_api_endpoint = ENV["THEHIVE_API_ENDPOINT"]
      @thehive_api_key = ENV["THEHIVE_API_KEY"]
      @urlscan_api_key = ENV["URLSCAN_API_KEY"]
      @virustotal_api_key = ENV["VIRUSTOTAL_API_KEY"]
      @zoomeye_api_key = ENV["ZOOMEYE_API_KEY"]

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

      def initialize_yaml(filename)
        keys = new.instance_variables.map do |key|
          key.to_s[1..]
        end

        config = keys.map do |key|
          [key, nil]
        end.to_h

        YAML.dump(config, File.open(filename, "w"))
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
