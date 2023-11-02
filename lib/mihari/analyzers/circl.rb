# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # CIRCL passive DNS/SSL analyzer
    #
    class CIRCL < Base
      include Mixins::Refang

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :username

      # @return [String, nil]
      attr_reader :password

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] username
      # @param [String, nil] password
      #
      def initialize(query, options: nil, username: nil, password: nil)
        super(refang(query), options: options)

        @type = TypeChecker.type(query)

        @username = username || Mihari.config.circl_passive_username
        @password = password || Mihari.config.circl_passive_password
      end

      def artifacts
        case type
        when "domain"
          client.passive_dns_search query
        when "hash"
          client.passive_ssl_search query
        else
          raise ValueError, "#{@query}(type: #{@type || "unknown"}) is not supported."
        end
      end

      def configured?
        configuration_keys? || (username? && password?)
      end

      def configuration_keys
        %w[circl_passive_password circl_passive_username]
      end

      private

      def client
        Clients::CIRCL.new(username: username, password: password, timeout: timeout)
      end

      def username?
        !username.nil?
      end

      def password?
        !password.nil?
      end
    end
  end
end
