module Mihari
  class Config
    # @return [String, nil]
    attr_reader :binaryedge_api_key

    # @return [String, nil]
    attr_reader :censys_id

    # @return [String, nil]
    attr_reader :censys_secret

    # @return [String, nil]
    attr_reader :circl_passive_password

    # @return [String, nil]
    attr_reader :circl_passive_username

    # @return [URI]
    attr_reader :database_url

    # @return [String, nil]
    attr_reader :greynoise_api_key

    # @return [String, nil]
    attr_reader :hunterhow_api_key

    # @return [String, nil]
    attr_reader :ipinfo_api_key

    # @return [String, nil]
    attr_reader :misp_url

    # @return [String, nil]
    attr_reader :misp_api_key

    # @return [String, nil]
    attr_reader :onyphe_api_key

    # @return [String, nil]
    attr_reader :otx_api_key

    # @return [String, nil]
    attr_reader :passivetotal_api_key

    # @return [String, nil]
    attr_reader :passivetotal_username

    # @return [String, nil]
    attr_reader :pulsedive_api_key

    # @return [String, nil]
    attr_reader :securitytrails_api_key

    # @return [String, nil]
    attr_reader :shodan_api_key

    # @return [String, nil]
    attr_reader :slack_channel

    # @return [String, nil]
    attr_reader :slack_webhook_url

    # @return [String, nil]
    attr_reader :thehive_url

    # @return [String, nil]
    attr_reader :thehive_api_key

    # @return [String, nil]
    attr_reader :thehive_api_version

    # @return [String, nil]
    attr_reader :urlscan_api_key

    # @return [String, nil]
    attr_reader :virustotal_api_key

    # @return [String, nil]
    attr_reader :zoomeye_api_key

    # @return [String, nil]
    attr_reader :sentry_dsn

    # @return [Boolean]
    attr_accessor :hide_config_values

    # @return [Integer]
    attr_reader :retry_interval

    # @return [Integer]
    attr_reader :retry_times

    # @return [Boolean]
    attr_reader :retry_exponential_backoff

    # @return [Integer]
    attr_reader :pagination_interval

    # @return [Integer]
    attr_reader :pagination_limit

    # @return [Boolean]
    attr_reader :ignore_error

    def initialize
      load
    end

    def load
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

      @hide_config_values = ENV.fetch("HIDE_CONFIG_VALUES", true)

      @retry_times = ENV.fetch("RETRY_TIMES", 3).to_i
      @retry_interval = ENV.fetch("RETRY_INTERVAL", 5).to_i
      @retry_exponential_backoff = ENV.fetch("RETRY_EXPONENTIAL_BACKOFF", true).to_s.downcase == "true"

      @pagination_interval = ENV.fetch("PAGINATION_INTERVAL", 0).to_i
      @pagination_limit = ENV.fetch("PAGINATION_LIMIT", 100).to_i

      @ignore_error = ENV.fetch("IGNORE_ERROR", false)
    end

    #
    # @return [Array<String>]
    #
    def keys
      instance_variables.map do |key|
        key[1..].to_s.upcase
      end
    end
  end
end
