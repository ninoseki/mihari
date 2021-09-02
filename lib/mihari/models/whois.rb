# frozen_string_literal: true

require "active_record"
require "whois-parser"
require "public_suffix"

module Mihari
  class WhoisRecord < ActiveRecord::Base
    belongs_to :artifact

    @memo = {}

    class << self
      #
      # Build whois record
      #
      # @param [Stinrg] domain
      #
      # @return [WhoisRecord, nil]
      #
      def build_by_domain(domain)
        domain = PublicSuffix.domain(domain)

        # check memo
        if @memo.key?(domain)
          whois_record = @memo[domain]
          # return clone of the record
          return whois_record.dup
        end

        record = Whois.whois(domain)
        parser = record.parser

        return nil if parser.available?

        whois_record = new(
          domain: domain,
          created_on: get_created_on(parser),
          updated_on: get_updated_on(parser),
          expires_on: get_expires_on(parser),
          registrar: get_registrar(parser),
          contacts: get_contacts(parser)
        )
        # set memo
        @memo[domain] = whois_record
        whois_record
      rescue Whois::Error, Whois::ParserError, Timeout::Error
        nil
      end

      private

      #
      # Get created_on
      #
      # @param [::Whois::Parser:] parser
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
      # @param [::Whois::Parser:] parser
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
      # @param [::Whois::Parser:] parser
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
      # @param [::Whois::Parser:] parser
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
      # @param [::Whois::Parser:] parser
      #
      # @return [Array[Hash], nil]
      #
      def get_contacts(parser)
        parser.contacts.map(&:to_h)
      rescue ::Whois::AttributeNotImplemented
        nil
      end
    end
  end
end
