# frozen_string_literal: true

module Mihari
  module Analyzers
    class Pulsedive < Base
      include Mixins::Refang

      param :query

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :api_key

      # @return [Integer]
      attr_reader :query

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

      def client
        @client ||= Clients::PulseDive.new(api_key: api_key)
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

        indicator = client.get_indicator(query)
        iid = indicator["iid"]

        properties = client.get_properties(iid)
        (properties["dns"] || []).filter_map do |property|
          if %w[A PTR].include?(property["name"])
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
