# frozen_string_literal: true

module Mihari
  module Analyzers
    class Censys < Base
      # @return [String, nil]
      attr_reader :id

      # @return [String, nil]
      attr_reader :secret

      #
      # @param [String] query
      # @param [hash, nil] options
      # @param [String, nil] api_key
      # @param [String, nil] id
      # @param [String, nil] secret
      #
      def initialize(query, options: nil, id: nil, secret: nil)
        super(query, options: options)

        @id = id || Mihari.config.censys_id
        @secret = secret || Mihari.config.censys_secret
      end

      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        artifacts = []

        cursor = nil
        pagination_limit.times do
          response = client.search(query, cursor: cursor)
          artifacts << response.result.to_artifacts
          cursor = response.result.links.next
          # NOTE: Censys's search API is unstable recently
          # it may returns empty links or empty string cursors
          # - Empty links: "links": {}
          # - Empty cursors: "links": { "next": "", "prev": "" }
          # So it needs to check both cases
          break if cursor.nil? || cursor.empty?

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep_interval
        end

        artifacts.flatten.uniq(&:data)
      end

      #
      # @return [Boolean]
      #
      def configured?
        configuration_keys? || (id? && secret?)
      end

      private

      #
      # @return [Array<String>]
      #
      def configuration_keys
        %w[censys_id censys_secret]
      end

      #
      # @return [Mihari::Clients::Censys]
      #
      def client
        @client ||= Clients::Censys.new(id: id, secret: secret)
      end

      #
      # @return [Boolean]
      #
      def id?
        !id.nil?
      end

      #
      # @return [Boolean]
      #
      def secret?
        !secret.nil?
      end
    end
  end
end
