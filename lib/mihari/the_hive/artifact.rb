# frozen_string_literal: true

module Mihari
  class TheHive
    class Artifact < Base
      # @return [Array]
      def search(data:, data_type:, range: "all")
        api.artifact.search({ data: data, data_type: data_type }, range: range)
      end

      # @return [Array]
      def search_all(data:, range: "all")
        api.artifact.search({ data: data }, range: range)
      end

      # @return [true, false]
      def exists?(data:, data_type:)
        res = search(data: data, data_type: data_type, range: "0-1")
        !res.empty?
      end

      # @return [Array<Mihari::Artifact>]
      def find_non_existing_artifacts(artifacts)
        data = artifacts.map(&:data)
        results = search_all(data: data)
        keys = results.map { |result| result.dig("data") }.compact.uniq
        artifacts.reject do |artifact|
          keys.include? artifact.data
        end
      end
    end
  end
end
