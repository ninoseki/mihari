# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    #
    # Fofa API client
    #
    class Fofa < Base
      PAGE_SIZE = 10_000

      # @return [String]
      attr_reader :api_key

      # @return [String]
      attr_reader :email

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [String, nil] email
      # @param [Hash] headers
      # @param [Integer] pagination_interval
      # @param [Integer, nil] timeout
      #
      # @param [Object] email
      def initialize(
        base_url = "https://fofa.info/",
        api_key:,
        email:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") unless api_key
        raise(ArgumentError, "email is required") unless email

        @api_key = api_key
        @email = email

        super(base_url, headers: headers, pagination_interval: pagination_interval, timeout: timeout)
      end

      #
      # @param [String] query
      # @param [Integer] size
      # @param [Integer] page
      #
      # @return [Mihari::Structs::Fofa::Response]
      #
      def search(query, page:, size: PAGE_SIZE)
        qbase64 = Base64.urlsafe_encode64(query)
        params = { qbase64: qbase64, size: size, page: page, email: email, key: api_key }.compact
        res = get("/api/v1/search/all", params: params)
        Structs::Fofa::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      #
      # @param [String] query
      # @param [Integer] size
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Mihari::Structs::Fofa::Response>]
      #
      def search_with_pagination(query, size: PAGE_SIZE, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = search(query, page: page, size: size)

            y.yield res

            break if res.error

            break if (res.results || []).length < size

            sleep_pagination_interval
          end
        end
      end
    end
  end
end
