# frozen_string_literal: true

require "anyway_config"

module Mihari
  class Config < Anyway::Config
    config_name :mihari
    env_prefix ""

    attr_config(
      # analyzers, emitters & enrichers
      binaryedge_api_key: nil,
      censys_id: nil,
      censys_secret: nil,
      circl_passive_password: nil,
      circl_passive_username: nil,
      database_url: URI("sqlite3:mihari.db"),
      fofa_api_key: nil,
      fofa_email: nil,
      greynoise_api_key: nil,
      hunterhow_api_key: nil,
      ipinfo_api_key: nil,
      misp_api_key: nil,
      misp_url: nil,
      onyphe_api_key: nil,
      otx_api_key: nil,
      passivetotal_api_key: nil,
      passivetotal_username: nil,
      pulsedive_api_key: nil,
      securitytrails_api_key: nil,
      shodan_api_key: nil,
      slack_channel: nil,
      slack_webhook_url: nil,
      thehive_api_key: nil,
      thehive_api_version: nil,
      thehive_url: nil,
      urlscan_api_key: nil,
      virustotal_api_key: nil,
      zoomeye_api_key: nil,
      # sidekiq
      redis_url: URI("redis://localhost:6379"),
      # others
      hide_config_values: true,
      ignore_error: false,
      pagination_interval: 0,
      pagination_limit: 100,
      parallel: false,
      retry_exponential_backoff: true,
      retry_interval: 5,
      retry_times: 3,
      sentry_dsn: nil,
      sentry_trace_sample_rate: 0.25
    )

    # @!attribute [r] binaryedge_api_key
    #   @return [String, nil]

    # @!attribute [r] censys_id
    #   @return [String, nil]

    # @!attribute [r] circl_passive_password
    #   @return [String, nil]

    # @!attribute [r] circl_passive_username
    #   @return [String, nil]

    # @!attribute [r] database_url
    #   @return [URI]

    # @!attribute [r] fofa_api_key
    #   @return [String, nil]

    # @!attribute [r] fofa_email
    #   @return [String, nil]

    # @!attribute [r] greynoise_api_key
    #   @return [String, nil]

    # @!attribute [r] hunterhow_api_key
    #   @return [String, nil]

    # @!attribute [r] ipinfo_api_key
    #   @return [String, nil]

    # @!attribute [r] misp_url
    #   @return [String, nil]

    # @!attribute [r] misp_api_key
    #   @return [String, nil]

    # @!attribute [r] onyphe_api_key
    #   @return [String, nil]

    # @!attribute [r] otx_api_key
    #   @return [String, nil]

    # @!attribute [r] passivetotal_api_key
    #   @return [String, nil]

    # @!attribute [r] passivetotal_username
    #   @return [String, nil]

    # @!attribute [r] pulsedive_api_key
    #   @return [String, nil]

    # @!attribute [r] securitytrails_api_key
    #   @return [String, nil]

    # @!attribute [r] shodan_api_key
    #   @return [String, nil]

    # @!attribute [r] slack_channel
    #   @return [String, nil]

    # @!attribute [r] slack_webhook_url
    #   @return [String, nil]

    # @!attribute [r] thehive_url
    #   @return [String, nil]

    # @!attribute [r] thehive_api_key
    #   @return [String, nil]

    # @!attribute [r] thehive_api_version
    #   @return [String, nil]

    # @!attribute [r] urlscan_api_key
    #   @return [String, nil]

    # @!attribute [r] virustotal_api_key
    #   @return [String, nil]

    # @!attribute [r] zoomeye_api_key
    #   @return [String, nil]

    # @!attribute [r] sentry_dsn
    #   @return [String, nil]

    # @!attribute [r] sentry_trace_sample_rate
    #   @return [Float]

    # @!attribute [r] retry_interval
    #   @return [Integer]

    # @!attribute [r] retry_times
    #   @return [Integer]

    # @!attribute [r] retry_exponential_backoff
    #   @return [Boolean]

    # @!attribute [r] pagination_interval
    #   @return [Integer]

    # @!attribute [r] pagination_limit
    #   @return [Integer]

    # @!attribute [r] parallel
    #   @return [Boolean]

    # @!attribute [r] ignore_error
    #   @return [Boolean]

    # @!attribute [r] hide_config_values
    #   @return [Boolean]

    # @!attribute [r] redis_url
    #   @return [URI]

    def database_url=(val)
      super(URI(val.to_s))
    end

    def redis_url=(val)
      super(URI(val.to_s))
    end

    #
    # @return [Array<String>]
    #
    def keys
      to_h.keys.map(&:to_s).map(&:upcase)
    end
  end
end
