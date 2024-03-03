# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # Whois enricher
    #
    class Whois < Base
      prepend MemoWise

      #
      # Query IAIA Whois API
      #
      # @param [Mihari::Models::Artifact] artifact
      #
      def call(artifact)
        return if artifact.domain.nil?

        artifact.whois_record ||= memoized_lookup(PublicSuffix.domain(artifact.domain))
      end

      private

      def client
        @client ||= Clients::Whois.new(timeout:)
      end

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Boolean]
      #
      def callable_relationships?(artifact)
        artifact.whois_record.nil?
      end

      def supported_data_types
        %w[url domain]
      end

      #
      # @param [String] domain
      #
      # @return [Mihari::Models::WhoisRecord, nil]
      #
      def memoized_lookup(domain)
        client.lookup domain
      end
      memo_wise :memoized_lookup
    end
  end
end
