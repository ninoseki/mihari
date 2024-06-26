# frozen_string_literal: true

# Rack
require "rack"
require "rack/cors"
require "rack/session"
require "rackup"

require "rack/handler/puma"

# Grape
require "grape-swagger"
require "grape-swagger-entity"

require "launchy"

require "mihari/web/middleware/connection"
require "mihari/web/middleware/capture_exceptions"

require "mihari/web/api"

# Sidekiq
require "sidekiq/web"

require "mihari/sidekiq/application"

module Mihari
  module Web
    #
    # Rack + Grape based web app
    #
    class App
      # @return [Array<String>]
      attr_reader :filenames

      # @return [Rack::Static]
      attr_reader :rack_static

      def initialize
        @filenames = ["", ".html", "index.html", "/index.html"]
        @rack_static = Rack::Static.new(
          -> { [404, {}, []] },
          root: File.expand_path("./public", __dir__),
          urls: ["/"]
        )
      end

      def call(env)
        status, headers, body = API.call(env)
        return [status, headers, body] unless headers["x-cascade"] == "pass"

        req = Rack::Request.new(env)
        # Check if the App wants us to pass the response along to others
        filenames.each do |path|
          static_status, static_headers, static_body = rack_static.call(env.merge("PATH_INFO" => req.path_info + path))
          return [static_status, static_headers, static_body] if static_status != 404
        end

        [status, headers, body]
      end

      class << self
        def instance
          Rack::Builder.new do
            use Rack::Cors do
              allow do
                origins "*"
                resource "*", headers: :any, methods: %i[get post put delete options]
              end
            end
            use Middleware::Connection
            use Middleware::CaptureExceptions
            use BetterErrors::Middleware if Mihari.development? && defined?(BetterErrors::Middleware)

            if Mihari.sidekiq?
              use Rack::Session::Cookie, secret: SecureRandom.hex(32), same_site: true, max_age: 86_400

              map "/sidekiq" do
                run Sidekiq::Web
              end
            end

            run App.new
          end.to_app
        end

        def run!(port: 9292, host: "localhost", threads: "0:5", verbose: false, worker_timeout: 60, open: true)
          # set maximum number of threads to use as PARALLEL_PROCESSOR_COUNT (if it is not set)
          # ref. https://github.com/grosser/parallel#tips
          # TODO: is this the best way?
          _min_thread, max_thread = threads.split(":")
          ENV["PARALLEL_PROCESSOR_COUNT"] ||= max_thread

          Rackup::Handler::Puma.run(
            instance,
            Port: port,
            Host: host,
            Threads: threads,
            Verbose: verbose,
            worker_timeout:
          ) do |_|
            Launchy.open("http://#{host}:#{port}") if !Mihari.development? && open
          rescue Launchy::CommandNotFoundError
            # ref. https://github.com/ninoseki/mihari/issues/477
            # do nothing
          end
        end
      end
    end
  end
end
