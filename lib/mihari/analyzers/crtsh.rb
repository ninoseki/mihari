# frozen_string_literal: true

require "crtsh"

module Mihari
  module Analyzers
    class Crtsh < Base
      param :query

      option :exclude_expired, default: proc { true }

      def artifacts
        results = search
        results.map do |result|
          values = result["name_value"].to_s.lines.map(&:chomp)
          values.map do |value|
            Artifact.new(data: value, source: source, metadata: result)
          end
        end.flatten
      end

      private

      def api
        @api ||= ::Crtsh::API.new
      end

      #
      # Search
      #
      # @return [Array<Hash>]
      #
      def search
        exclude = exclude_expired ? "expired" : nil
        api.search(query, exclude: exclude)
      rescue ::Crtsh::Error => _e
        []
      end
    end
  end
end
