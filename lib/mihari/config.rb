module Mihari
  class Config
    # @return [String, nil]
    attr_accessor :binaryedge_api_key

    # @return [String, nil]
    attr_accessor :censys_id

    # @return [String, nil]
    attr_accessor :censys_secret

    # @return [String, nil]
    attr_accessor :circl_passive_password

    # @return [String, nil]
    attr_accessor :circl_passive_username

    # @return [URI]
    attr_accessor :database_url

    # @return [String, nil]
    attr_accessor :greynoise_api_key

    # @return [String, nil]
    attr_accessor :hunterhow_api_key

    # @return [String, nil]
    attr_accessor :ipinfo_api_key

    # @return [String, nil]
    attr_accessor :misp_url

    # @return [String, nil]
    attr_accessor :misp_api_key

    # @return [String, nil]
    attr_accessor :onyphe_api_key

    # @return [String, nil]
    attr_accessor :otx_api_key

    # @return [String, nil]
    attr_accessor :passivetotal_api_key

    # @return [String, nil]
    attr_accessor :passivetotal_username

    # @return [String, nil]
    attr_accessor :pulsedive_api_key

    # @return [String, nil]
    attr_accessor :securitytrails_api_key

    # @return [String, nil]
    attr_accessor :shodan_api_key

    # @return [String, nil]
    attr_accessor :slack_channel

    # @return [String, nil]
    attr_accessor :slack_webhook_url

    # @return [String, nil]
    attr_accessor :thehive_url

    # @return [String, nil]
    attr_accessor :thehive_api_key

    # @return [String, nil]
    attr_accessor :thehive_api_version

    # @return [String, nil]
    attr_accessor :urlscan_api_key

    # @return [String, nil]
    attr_accessor :virustotal_api_key

    # @return [String, nil]
    attr_accessor :zoomeye_api_key

    # @return [String, nil]
    attr_accessor :sentry_dsn

    # @return [String, nil]
    attr_accessor :hide_config_values

    def initialize
      @binaryedge_api_key = ENV.fetch("BINARYEDGE_API_KEY", nil)

      @censys_id = ENV.fetch("CENSYS_ID", nil)
      @censys_secret = ENV.fetch("CENSYS_SECRET", nil)

      @circl_passive_password = ENV.fetch("CIRCL_PASSIVE_PASSWORD", nil)
      @circl_passive_username = ENV.fetch("CIRCL_PASSIVE_USERNAME", nil)

      @database_url = URI(ENV.fetch("DATABASE_URL", "sqlite3:///mihari.db"))

      @greynoise_api_key = ENV.fetch("GREYNOISE_API_KEY", nil)

      @ipinfo_api_key = ENV.fetch("IPINFO_API_KEY", nil)

      @hunterhow_api_key = ENV.fetch("HUNTERHOW_API_KEY", nil)

      @misp_url = ENV.fetch("MISP_URL", nil)
      @misp_api_key = ENV.fetch("MISP_API_KEY", nil)

      @onyphe_api_key = ENV.fetch("ONYPHE_API_KEY", nil)

      @otx_api_key = ENV.fetch("OTX_API_KEY", nil)

      @passivetotal_api_key = ENV.fetch("PASSIVETOTAL_API_KEY", nil)
      @passivetotal_username = ENV.fetch("PASSIVETOTAL_USERNAME", nil)

      @pulsedive_api_key = ENV.fetch("PULSEDIVE_API_KEY", nil)

      @securitytrails_api_key = ENV.fetch("SECURITYTRAILS_API_KEY", nil)

      @shodan_api_key = ENV.fetch("SHODAN_API_KEY", nil)

      @slack_channel = ENV.fetch("SLACK_CHANNEL", nil)
      @slack_webhook_url = ENV.fetch("SLACK_WEBHOOK_URL", nil)

      @thehive_url = ENV.fetch("THEHIVE_URL", nil)
      @thehive_api_key = ENV.fetch("THEHIVE_API_KEY", nil)
      @thehive_api_version = ENV.fetch("THEHIVE_API_VERSION", nil)

      @urlscan_api_key = ENV.fetch("URLSCAN_API_KEY", nil)

      @virustotal_api_key = ENV.fetch("VIRUSTOTAL_API_KEY", nil)

      @zoomeye_api_key = ENV.fetch("ZOOMEYE_API_KEY", nil)

      @sentry_dsn = ENV.fetch("SENTRY_DSN", nil)

      @hide_config_values = ENV.fetch("HIDE_CONFIG_VALUES", false)
    end
  end
end
