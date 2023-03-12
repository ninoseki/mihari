# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    class CIRCL < Base
      #
      # @param [String] base_url
      # @param [String, nil] username
      # @param [String, nil] password
      # @param [Hash] headers
      #
      def initialize(base_url = "https://www.circl.lu", username:, password:, headers: {})
        raise(ArgumentError, "'username' argument is required") if username.nil?
        raise(ArgumentError, "'password' argument is required") if password.nil?

        headers["authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{password}")}"

        super(base_url, headers: headers)
      end

      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def dns_query(query)
        _get("/pdns/query/#{query}")
      end

      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def ssl_cquery(query)
        _get("/v2pssl/cquery/#{query}")
      end

      private

      #
      #
      # @param [String] path
      # @param [Hash] params
      #
      def _get(path, params: {})
        res = get(path, params: params)
        body = res.body.to_s
        content_type = res["Content-Type"].to_s

        return JSON.parse(body) if content_type.include?("application/json")

        body.lines.map { |line| JSON.parse line }
      end
    end
  end
end
