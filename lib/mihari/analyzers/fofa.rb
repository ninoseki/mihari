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
        super(query, options:)

        @api_key = api_key || Mihari.config.fofa_api_key
        @email = email || Mihari.config.fofa_email
      end

      def artifacts
        client.search_with_pagination(query, pagination_limit:).map do |res|
          (res.results || []).map { |result| result[1] }
        end.flatten.compact
      end

      def configured?
        api_key? && email?
      end

      private

      def email?
        !email.nil?
      end

      #
      # @return [Mihari::Clients::Fofa]
      #
      def client
        Clients::Fofa.new(
          api_key:,
          email:,
          pagination_interval:,
          timeout:
        )
      end
    end
  end
end
