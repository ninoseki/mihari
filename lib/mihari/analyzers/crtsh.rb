# frozen_string_literal: true

require "crtsh"

module Mihari
  module Analyzers
    class Crtsh < Base
      param :query
      option :title, default: proc { "crt.sh lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }
      option :exclude_expired, default: proc { true }

      def artifacts
        results = search
        name_values = results.filter_map { |result| result["name_value"] }
        name_values.map(&:lines).flatten.uniq.map(&:chomp)
      end

      private

      def api
        @api ||= ::Crtsh::API.new
      end

      def search
        exclude = exclude_expired ? "expired" : nil
        api.search(query, exclude: exclude)
      rescue ::Crtsh::Error => _e
        []
      end
    end
  end
end
