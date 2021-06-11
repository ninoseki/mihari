# frozen_string_literal: true

require "pulsedive"

module Mihari
  module Analyzers
    class Pulsedive < Base
      include Mixins::Utils

      param :query
      option :title, default: proc { "Pulsedive lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      attr_reader :type

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        %w[pulsedive_api_key]
      end

      def api
        @api ||= ::Pulsedive::API.new(Mihari.config.pulsedive_api_key)
      end

      def valid_type?
        %w[ip domain].include? type
      end

      def lookup
        raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

        indicator = api.indicator.get_by_value(query)
        iid = indicator["iid"]

        properties = api.indicator.get_properties_by_id(iid)
        (properties["dns"] || []).filter_map do |property|
          property["value"] if ["A", "PTR"].include?(property["name"])
        end
      end
    end
  end
end
