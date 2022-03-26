# frozen_string_literal: true

require "pulsedive"

module Mihari
  module Analyzers
    class Pulsedive < Base
      include Mixins::Refang

      param :query

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)

        @api_key = kwargs[:api_key] || Mihari.config.pulsedive_api_key
      end

      def artifacts
        search || []
      end

      private

      def configuration_keys
        %w[pulsedive_api_key]
      end

      def api
        @api ||= ::Pulsedive::API.new(api_key)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain].include? type
      end

      #
      # Search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def search
        raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

        indicator = api.indicator.get_by_value(query)
        iid = indicator["iid"]

        properties = api.indicator.get_properties_by_id(iid)
        (properties["dns"] || []).filter_map do |property|
          if ["A", "PTR"].include?(property["name"])
            nil
          else
            data = property["value"]
            Artifact.new(data: data, source: source, metadata: property)
          end
        end
      end
    end
  end
end
