# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # MMDB enricher
    #
    class MMDB < Base
      #
      # Query MMDB
      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::MMDB::Response]
      #
      def call(ip)
        client.query ip
      end
      memo_wise :call

      private

      def client
        @client ||= Clients::MMDB.new(timeout: timeout)
      end
    end
  end
end
