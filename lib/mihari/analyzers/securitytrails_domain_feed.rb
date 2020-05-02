# frozen_string_literal: true

require "securitytrails"

module Mihari
  module Analyzers
    class SecurityTrailsDomainFeed < Base
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(regexp, type: "registered", title: nil, description: nil, tags: [])
        super()

        @_regexp = regexp
        @type = type

        raise InvalidInputError, "#{@_regexp} is not a valid regexp" unless regexp
        raise InvalidInputError, "#{type} is not a valid type" unless valid_type?

        @title = title || "SecurityTrails domain feed lookup"
        @description = description || "Regexp = /#{@_regexp}/"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        [Mihari.config.securitytrails_api_key]
      end

      def api
        @api ||= ::SecurityTrails::API.new(Mihari.config.securitytrails_api_key)
      end

      def valid_type?
        %w(all new registered).include? type
      end

      def regexp
        @regexp ||= Regexp.compile(@_regexp)
      rescue InvalidInputError => _e
        nil
      end

      def lookup
        new_domains.select do |domain|
          regexp.match? domain
        end
      end

      def new_domains
        api.feeds.domains type
      end
    end
  end
end
