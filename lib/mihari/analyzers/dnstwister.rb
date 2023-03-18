# frozen_string_literal: true

module Mihari
  module Analyzers
    class DNSTwister < Base
      include Mixins::Refang

      param :query

      # @return [String]
      attr_reader :type

      # @return [String]
      attr_reader :query

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)
      end

      def artifacts
        raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

        res = client.fuzz(query)
        fuzzy_domains = res["fuzzy_domains"] || []
        domains = fuzzy_domains.map { |domain| domain["domain"] }
        Parallel.map(domains) do |domain|
          resolvable?(domain) ? domain : nil
        end.compact
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

      def client
        @client ||= Clients::DNSTwister.new
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
    end
  end
end
