# frozen_string_literal: true

module Mihari
  module Analyzers
    class Censys < Base
      # @return [String, nil]
      attr_reader :id

      # @return [String, nil]
      attr_reader :secret

      #
      # @param [String] query
      # @param [hash, nil] options
      # @param [String, nil] api_key
      # @param [String, nil] id
      # @param [String, nil] secret
      #
      def initialize(query, options: nil, id: nil, secret: nil)
        super(query, options: options)

        @id = id || Mihari.config.censys_id
        @secret = secret || Mihari.config.censys_secret
      end

      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        client.search_with_pagination(query, pagination_limit: pagination_limit).map do |res|
          res.result.artifacts
        end.flatten.uniq(&:data)
      end

      #
      # @return [Boolean]
      #
      def configured?
        configuration_keys? || (id? && secret?)
      end

      #
      # @return [Array<String>]
      #
      def configuration_keys
        %w[censys_id censys_secret]
      end

      private

      #
      # @return [Mihari::Clients::Censys]
      #
      def client
        @client ||= Clients::Censys.new(id: id, secret: secret, interval: interval)
      end

      #
      # @return [Boolean]
      #
      def id?
        !id.nil?
      end

      #
      # @return [Boolean]
      #
      def secret?
        !secret.nil?
      end
    end
  end
end
