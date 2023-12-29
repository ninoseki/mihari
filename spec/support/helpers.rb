# frozen_string_literal: true

require "capybara"
require_relative "fake_http_bin"

module Spec
  module Support
    class Dummy
      def initialize(...)
        @logs = []
        super(...)
      end

      def last_request
        @logs.last
      end

      def call(env)
        @logs << Rack::Request.new(env)
        [200, {}, [""]]
      end
    end

    module Helpers
      def fake_httpbin_server
        Capybara::Server.new FakeHTTPBin
      end
    end
  end
end
