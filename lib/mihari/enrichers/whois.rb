# frozen_string_literal: true

require "whois-parser"

module Mihari
  module Enrichers
    #
    # Whois enricher
    #
    class Whois < Base
      #
      # @param [Hash, nil] options
      #
      def initialize(options: nil)
        super(options: options)
      end

      #
      # Query IAIA Whois API
      #
      # @param [String] domain
      #
      # @return [Mihari::Models::WhoisRecord, nil]
      #
      def call(domain)
        memoized_call PublicSuffix.domain(domain)
      end

      private

      #
      # @param [String] domain
      #
      # @return [Mihari::Models::WhoisRecord, nil]
      #
      def memoized_call(domain)
        record = whois.lookup(domain)
        parser = record.parser
        return nil if parser.available?

        Models::WhoisRecord.new(
          domain: domain,
          created_on: get_created_on(parser),
          updated_on: get_updated_on(parser),
          expires_on: get_expires_on(parser),
          registrar: get_registrar(parser),
          contacts: get_contacts(parser)
        )
      end
      memo_wise :memoized_call

      #
      # @return [::Whois::Client]
      #
      def whois
        @whois ||= lambda do
          return ::Whois::Client.new if timeout.nil?

          ::Whois::Client.new(timeout: timeout)
        end.call
      end

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
