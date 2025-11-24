# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Censys analyzer
    #
    class Censys < Base
      LEGACY_VERSION = 2
      PLATFORM_VERSION = 3

      attr_reader :id, :secret, :api_key, :organization_id, :version

      def initialize(query, options: nil, id: nil, secret: nil, api_key: nil, organization_id: nil)
        super(query, options:)

        @version_explicit = options&.key?(:version) || options&.key?("version")
        @legacy_warning_emitted = false
        @version = determine_version(options)

        if platform?
          @api_key = api_key || Mihari.config.censys_v3_api_key
          @organization_id = organization_id || Mihari.config.censys_v3_org_id
        else
          @id = id || Mihari.config.censys_id
          @secret = secret || Mihari.config.censys_secret
        end
      end

      def artifacts
        client.search_with_pagination(query, pagination_limit:).flat_map do |res|
          platform? ? res.artifacts : res.result.artifacts
        end.uniq(&:data)
      end

      def configured?
        platform? ? platform_configured? : legacy_configured?
      end

      private

      def determine_version(options)
        raw = options&.dig(:version) || options&.dig("version")
        return legacy_version_with_warning unless raw

        value = raw.to_i
        raise ArgumentError, "Unsupported Censys API version: #{raw}" unless [LEGACY_VERSION, PLATFORM_VERSION].include?(value)

        value
      end

      def legacy_version_with_warning
        warn_legacy_usage_once
        LEGACY_VERSION
      end

      def warn_legacy_usage_once
        return if @version_explicit || @legacy_warning_emitted

        Mihari.logger.warn(
          "Analyzer:censys is defaulting to the legacy Censys Search API (version 2). " \
          "Set options.version: 3 to switch to the Censys Platform API before legacy support is removed."
        )
        @legacy_warning_emitted = true
      end

      def client
        platform? ? platform_client : legacy_client
      end

      def platform_client
        Clients::CensysV3.new(
          api_key: api_key,
          organization_id: organization_id,
          pagination_interval: pagination_interval,
          timeout: timeout
        )
      end

      def legacy_client
        Clients::Censys.new(
          id:,
          secret:,
          pagination_interval:,
          timeout:
        )
      end

      def platform?
        version == PLATFORM_VERSION
      end

      def legacy_configured?
        id? && secret?
      end

      def platform_configured?
        !api_key.nil?
      end

      def id?
        !id.nil?
      end

      def secret?
        !secret.nil?
      end

      class << self
        # Always list every relevant env var so the config page can surface version-specific credentials
        def configuration_items
          %i[
            censys_id
            censys_secret
            censys_v2_api_key
            censys_v2_org_id
            censys_v3_api_key
            censys_v3_org_id
          ].map do |config_key|
            value = Mihari.config.send(config_key)
            value = "REDACTED" if value && Mihari.config.hide_config_values
            {key: config_key.to_s.upcase, value:}
          end
        end
      end
    end
  end
end
