# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # DNSTwister analyzer
    #
    class DNSTwister < Base
      include Concerns::Refangable

      # @return [String]
      attr_reader :type

      #
      # @param [String] query
      # @param [Hash, nil] options
      #
      def initialize(query, options: nil)
        super(refang(query), options:)

        @type = DataType.type(query)
      end

      def artifacts
        raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

        domains = client.fuzz(query)
        Parallel.map(domains) { |domain| resolvable?(domain) ? domain : nil }.compact
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
        Clients::DNSTwister.new(timeout:)
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
      rescue Resolv::ResolvError
        false
      end
    end
  end
end
