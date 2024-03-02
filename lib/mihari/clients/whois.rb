# frozen_string_literal: true

require "whois-parser"

module Mihari
  module Clients
    #
    # Whois client
    #
    class Whois
      # @return [Integer, nil]
      attr_reader :timeout

      # @return [::Whois::Client]
      attr_reader :client

      #
      # @param [Integer, nil] timeout
      #
      def initialize(timeout: nil)
        @timeout = timeout

        @client = lambda do
          return ::Whois::Client.new if timeout.nil?

          ::Whois::Client.new(timeout:)
        end.call
      end

      #
      # Query IAIA Whois API
      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @param [Object] domain
      def lookup(domain)
        record = client.lookup(domain)
        return if record.parser.available?

        Models::WhoisRecord.new(
          domain:,
          created_on: get_created_on(record.parser),
          updated_on: get_updated_on(record.parser),
          expires_on: get_expires_on(record.parser),
          registrar: get_registrar(record.parser),
          contacts: get_contacts(record.parser)
        )
      end

      private

      #
      # Get created_on
      #
      # @param [::Whois::Parser] parser
      #
      # @return [Date, nil]
      #
      def get_created_on(parser)
        parser.created_on
      rescue ::Whois::AttributeNotImplemented
        nil
      end

      #
      # Get updated_on
      #
      # @param [::Whois::Parser] parser
      #
      # @return [Date, nil]
      #
      def get_updated_on(parser)
        parser.updated_on
      rescue ::Whois::AttributeNotImplemented
        nil
      end

      #
      # Get expires_on
      #
      # @param [::Whois::Parser] parser
      #
      # @return [Date, nil]
      #
      def get_expires_on(parser)
        parser.expires_on
      rescue ::Whois::AttributeNotImplemented
        nil
      end

      #
      # Get registrar
      #
      # @param [::Whois::Parser] parser
      #
      # @return [Hash, nil]
      #
      def get_registrar(parser)
        parser.registrar&.to_h
      rescue ::Whois::AttributeNotImplemented
        nil
      end

      #
      # Get contacts
      #
      # @param [::Whois::Parser] parser
      #
      # @return [Array<Hash>, nil]
      #
      def get_contacts(parser)
        parser.contacts.map(&:to_h)
      rescue ::Whois::AttributeNotImplemented
        nil
      end
    end
  end
end
