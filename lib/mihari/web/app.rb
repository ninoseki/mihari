# frozen_string_literal: true

require "launchy"
require "rack"
require "rack/contrib"
require "rack/handler/puma"
require "rack/cors"

require "grape-swagger"
require "grape-swagger-entity"

require "mihari/web/middleware/connection_adapter"
require "mihari/web/middleware/error_notification_adapter"

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
              resource "*", headers: :any, methods: %i[get post put delete options]
            end
          end

          use Middleware::ConnectionAdapter
          use Middleware::ErrorNotificationAdapter

          run App.new
        end.to_app
      end

      def run!(port: 9292, host: "localhost", threads: "0:5", verbose: false, worker_timeout: 60)
        url = "http://#{host}:#{port}"

        # set maximum number of threads to use as PARALLEL_PROCESSOR_COUNT (if it is not set)
        # ref. https://github.com/grosser/parallel#tips
        # TODO: is this the best way?
        _min_thread, max_thread = threads.split(":")
        ENV["PARALLEL_PROCESSOR_COUNT"] = max_thread if ENV["PARALLEL_PROCESSOR_COUNT"].nil?
        Rack::Handler::Puma.run(
          instance,
          Port: port,
          Host: host,
          Threads: threads,
          Verbose: verbose,
          worker_timeout: worker_timeout
        ) do |_launcher|
          Launchy.open(url) if ENV["RACK_ENV"] != "development"
        rescue Launchy::CommandNotFoundError
          # ref. https://github.com/ninoseki/mihari/issues/477
          # do nothing
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
