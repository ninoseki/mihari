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

        raise ArgumentError, "#{@_regexp} is not a valid regexp" unless regexp
        raise ArgumentError, "#{type} is not a valid type" unless valid_type?

        @title = title || "SecurityTrails domain feed lookup"
        @description = description || "Regexp = /#{@_regexp}/"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def keys
        %w(SECURITYTRAILS_API_KEY)
      end

      def api
        @api ||= ::SecurityTrails::API.new
      end

      def valid_type?
        %w(all new registered).include? type
      end

      def regexp
        @regexp ||= Regexp.compile(@_regexp)
      rescue TypeError => _e
        nil
      end

      def lookup
        new_domains.select do |domain|
          regexp.match? domain
        end
      rescue ::SecurityTrails::Error => _e
        nil
      end

      def new_domains
        api.feeds.domains type
      end
    end
  end
end
