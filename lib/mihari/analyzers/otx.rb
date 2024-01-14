# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # OTX analyzer
    #
    class OTX < Base
      include Concerns::Refangable

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

        @api_key = api_key || Mihari.config.otx_api_key
      end

      def artifacts
        case type
        when "domain"
          client.domain_search(query)
        when "ip"
          client.ip_search(query)
        else
          raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      private

      def client
        Mihari::Clients::OTX.new(api_key: api_key, timeout: timeout)
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
