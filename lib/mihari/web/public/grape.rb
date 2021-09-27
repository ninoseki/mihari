# frozen_string_literal: true

require "launchy"
require "rack"
require "rack/contrib"
require "rack/handler/puma"
require "rack/cors"

require "grape"
require "grape-swagger"

require "mihari/web/apis/ping"

module Mihari
  class API < Grape::API
    prefix "api"
    format :json
    mount Apis::Ping
    add_swagger_documentation api_version: "v1"
  end

  class GrapeApp
    def initialize
      @filenames = ["", ".html", "index.html", "/index.html"]
      @rack_static = ::Rack::Static.new(
        lambda { [404, {}, []] },
        root: File.expand_path("public", __dir__),
        urls: ["/"]
      )
    end

    class << self
      def instance
        @instance ||= Rack::Builder.new do
          run GrapeApp.new
        end.to_app
      end

      def run!(port: 9292, host: "localhost", threads: "0:16", verbose: false)
        url = "http://#{host}:#{port}"

        Rack::Handler::Puma.run(instance, Port: port, Host: host, Threads: threads, Verbose: verbose) do |server|
          p ENV["RACK_ENV"]
          p instance.class

          Launchy.open(url) if ENV["RACK_ENV"] != "development"

          [:INT, :TERM].each do |sig|
            trap(sig) do
              server.shutdown
            end
          end
        end
      end
    end

    def call(env)
      # api
      p GrapeApp.instance
      response = API.call(env)

      # Check if the App wants us to pass the response along to others
      if response[1]["X-Cascade"] == "pass"
        # static files
        request_path = env["PATH_INFO"]
        @filenames.each do |path|
          response = @rack_static.call(env.merge("PATH_INFO" => request_path + path))
          return response if response[0] != 404
        end
      end
    end
  end
end
