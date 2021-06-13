# frozen_string_literal: true

require "censysx"

module Mihari
  module Analyzers
    class Censys < Base
      param :query
      option :title, default: proc { "Censys search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      def artifacts
        search
      end

      private

      def search
        ipv4s = []

        cursor = nil
        loop do
          response = api.search(query, cursor: cursor)
          ipv4s << response_to_ipv4s(response)

          links = response.dig("result", "links")
          cursor = links["next"]
          break if cursor == ""
        end

        ipv4s.flatten
      end

      #
      # Extract IPv4s from Censys search API response
      #
      # @param [Hash] response
      #
      # @return [Array<String>]
      #
      def response_to_ipv4s(response)
        hits = response.dig("result", "hits") || []
        hits.map { |hit| hit["ip"] }
      end

      def configuration_keys
        %w[censys_id censys_secret]
      end

      def api
        @api ||= ::Censys::API.new(Mihari.config.censys_id, Mihari.config.censys_secret)
      end
    end
  end
end
