# frozen_string_literal: true

require "launchy"
require "rack"
require "rack/contrib"
require "rack/handler/puma"
require "rack/cors"

require "grape"
require "grape-entity"
require "grape-swagger"
require "grape-swagger-entity"

require "mihari/web/middleware/connection_adapter"

require "mihari/web/api"

module Mihari
  class App
    def initialize
      @filenames = ["", ".html", "index.html", "/index.html"]
      @rack_static = ::Rack::Static.new(
        -> { [404, {}, []] },
        root: File.expand_path("./public", __dir__),
        urls: ["/"]
      )
    end

    class << self
      def instance
        @instance ||= Rack::Builder.new do
          use Rack::Cors do
            allow do
              origins "*"
              resource "*", headers: :any, methods: [:get, :post, :put, :delete, :options]
            end
          end

          use Middleware::ConnectionAdapter

          run App.new
        end.to_app
      end

      def run!(port: 9292, host: "localhost", threads: "0:16", verbose: false)
        url = "http://#{host}:#{port}"

        Rack::Handler::Puma.run(instance, Port: port, Host: host, Threads: threads, Verbose: verbose) do |_launcher|
          Launchy.open(url) if ENV["RACK_ENV"] != "development"
        end
      end
    end

    def call(env)
      # api
      api_response = API.call(env)

      # Check if the App wants us to pass the response along to others
      if api_response[1]["X-Cascade"] == "pass"
        # static files
        request_path = env["PATH_INFO"]
        @filenames.each do |path|
          response = @rack_static.call(env.merge("PATH_INFO" => request_path + path))
          return response if response[0] != 404
        end
      end

      api_response
    end
  end
end
