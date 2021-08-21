# frozen_string_literal: true

require "active_record"
require "whois-parser"

module Mihari
  class WhoisRecord < ActiveRecord::Base
    has_one :artifact, dependent: :destroy

    class << self
      #
      # Build whois record
      #
      # @param [Stinrg] domain
      #
      # @return [WhoisRecord, nil]
      #
      def build_by_domain(domain)
        record = Whois.whois(domain)
        parser = record.parser

        return nil if parser.available?

        new(
          text: parser.record,
          created_on: get_created_on(parser),
          registrar: get_registrar(parser)
        )
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
      # Get registrar
      #
      # @param [::Whois::Parser:] parser
      #
      # @return [String, nil]
      #
      def get_registrar(parser)
        parser.registrar&.name
      rescue ::Whois::AttributeNotImplemented
        nil
      end
    end
  end
end
