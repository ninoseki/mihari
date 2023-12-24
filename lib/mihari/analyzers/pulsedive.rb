# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Pulsedive analyzer
    #
    class Pulsedive < Base
      include Mixins::Refangable

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(refang(query), options: options)

        @type = DataType.type(query)

        @api_key = api_key || Mihari.config.pulsedive_api_key
      end

      def artifacts
        raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

        indicator = client.get_indicator(query)
        iid = indicator["iid"]
        properties = client.get_properties(iid)
        (properties["dns"] || []).filter_map do |property|
          if %w[A PTR].include?(property["name"])
            nil
          else
            data = property["value"]
            Models::Artifact.new(data: data, metadata: property)
          end
        end
      end

      class << self
        def configuration_keys
          %w[pulsedive_api_key]
        end
      end

      private

      def client
        @client ||= Clients::PulseDive.new(api_key: api_key, timeout: timeout)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain].include? type
      end
    end
  end
end
