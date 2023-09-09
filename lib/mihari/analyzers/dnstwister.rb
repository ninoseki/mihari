# frozen_string_literal: true

module Mihari
  module Analyzers
    class DNSTwister < Base
      include Mixins::Refang

      # @return [String]
      attr_reader :type

      #
      # @param [String] query
      # @param [Hash, nil] options
      #
      def initialize(query, options: nil)
        super(refang(query), options: options)

        @type = TypeChecker.type(query)
      end

      def artifacts
        raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

        domains = client.fuzz(query)
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
