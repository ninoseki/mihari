# frozen_string_literal: true

module Mihari
  module Analyzers
    class Censys < Base
      param :query

      option :interval, default: proc { 0 }

      # @return [String, nil]
      attr_reader :id

      # @return [String, nil]
      attr_reader :secret

      # @return [Integer]
      attr_reader :interval

      # @return [String]
      attr_reader :query

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @id = kwargs[:id] || Mihari.config.censys_id
        @secret = kwargs[:secret] || Mihari.config.censys_secret
      end

      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        artifacts = []

        cursor = nil
        loop do
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
          sleep interval
        end

        artifacts.flatten.uniq(&:data)
      end

      #
      # @return [Boolean]
      #
      def configured?
        configuration_keys.all? { |key| Mihari.config.send(key) } || (id? && secret?)
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
