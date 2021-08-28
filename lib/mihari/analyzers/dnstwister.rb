# frozen_string_literal: true

require "dnstwister"
require "resolv"
require "parallel"

module Mihari
  module Analyzers
    class DNSTwister < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "dnstwister domain search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      attr_reader :type

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)
      end

      def artifacts
        search || []
      end

      private

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        type == "domain"
      end

      def api
        @api ||= ::DNSTwister::API.new
      end

      #
      # Check whether a domain is resolvable or not
      #
      # @param [String] domain
      #
      # @return [Boolean]
      #
      def resolvable?(domain)
        Resolv.getaddress domain
        true
      rescue Resolv::ResolvError => _e
        false
      end

      #
      # Search
      #
      # @return [Array<String>]
      #
      def search
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
