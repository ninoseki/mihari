# frozen_string_literal: true

module Mihari
  module Analyzers
    class CIRCL < Base
      include Mixins::Refang

      param :query

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :username

      # @return [String, nil]
      attr_reader :password

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)

        @username = kwargs[:username] || Mihari.config.circl_passive_username
        @password = kwargs[:password] || Mihari.config.circl_passive_password
      end

      def artifacts
        search || []
      end

      def configured?
        configuration_keys.all? { |key| Mihari.config.send(key) } || (username? && password?)
      end

      private

      def configuration_keys
        %w[circl_passive_password circl_passive_username]
      end

      def client
        @client ||= Clients::CIRCL.new(username: username, password: password)
      end

      #
      # Passive DNS/SSL search
      #
      # @return [Array<String>]
      #
      def search
        case @type
        when "domain"
          passive_dns_search
        when "hash"
          passive_ssl_search
        else
          raise InvalidInputError, "#{@query}(type: #{@type || "unknown"}) is not supported."
        end
      end

      #
      # Passive DNS search
      #
      # @return [Array<String>]
      #
      def passive_dns_search
        results = client.dns_query(@query)
        results.filter_map do |result|
          type = result["rrtype"]
          (type == "A") ? result["rdata"] : nil
        end.uniq
      end

      #
      # Passive SSL search
      #
      # @return [Array<String>]
      #
      def passive_ssl_search
        result = client.ssl_cquery(@query)
        seen = result["seen"] || []
        seen.uniq
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
