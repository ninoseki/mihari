# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Fofa analyzer
    #
    class Fofa < Base
      # @return [String, nil]
      attr_reader :api_key

      # @return [String, nil]
      attr_reader :email

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      # @param [String, nil] email
      #
      def initialize(query, options: nil, api_key: nil, email: nil)
        super(query, options: options)

        @api_key = api_key || Mihari.config.fofa_api_key
        @email = email || Mihari.config.fofa_email
      end

      def artifacts
        client.search_with_pagination(query, pagination_limit: pagination_limit).map do |res|
          (res.results || []).map { |result| result[1] }
        end.flatten.compact
      end

      def configuration_keys
        %w[fofa_api_key fofa_email]
      end

      private

      #
      # @return [Mihari::Clients::Fofa]
      #
      def client
        @client ||= Clients::Fofa.new(
          api_key: api_key,
          email: email,
          pagination_interval: pagination_interval,
          timeout: timeout
        )
      end
    end
  end
end
