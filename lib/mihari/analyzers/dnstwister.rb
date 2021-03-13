# frozen_string_literal: true

require "dnstwister"
require "resolv"
require "parallel"

module Mihari
  module Analyzers
    class DNSTwister < Base
      attr_reader :query, :type, :title, :description, :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @type = TypeChecker.type(query)

        @title = title || "dnstwister domain lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def valid_type?
        type == "domain"
      end

      def api
        @api ||= ::DNSTwister::API.new
      end

      def resolvable?(domain)
        Resolv.getaddress domain
        true
      rescue Resolv::ResolvError => _e
        false
      end

      def lookup
        raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

        res = api.fuzz(query)
        fuzzy_domains = res["fuzzy_domains"] || []
        domains = fuzzy_domains.map { |domain| domain["domain"] }
        Parallel.map(domains) do |domain|
          resolvable?(domain) ? domain : nil
        end.compact
      end
    end
  end
end
