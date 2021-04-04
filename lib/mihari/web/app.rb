# frozen_string_literal: true

require "awrence"
require "colorize"
require "launchy"
require "rack"
require "safe_shell"
require "sinatra"
require "sinatra/json"
require "sinatra/reloader"

require "mihari/web/controllers/alerts_controller"
require "mihari/web/controllers/artifacts_controller"
require "mihari/web/controllers/command_controller"
require "mihari/web/controllers/config_controller"
require "mihari/web/controllers/sources_controller"
require "mihari/web/controllers/tags_controller"

module Mihari
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(root, "public")

    get "/" do
      send_file File.join(settings.public_folder, "index.html")
    end

    register Sinatra::Reloader

    use Mihari::Controllers::AlertsController
    use Mihari::Controllers::ArtifactsController
    use Mihari::Controllers::CommandController
    use Mihari::Controllers::ConfigController
    use Mihari::Controllers::SourcesController
    use Mihari::Controllers::TagsController

    class << self
      def run!(port: 9292, host: "localhost")
        url = "http://#{host}:#{port}"

        puts "The app will be available at #{url}.".colorize(:blue)
        puts "(Press Ctrl+C to quit)".colorize(:blue)

        Rack::Handler::WEBrick.run self, Port: port, Host: host do |server|
          Launchy.open url

          [:INT, :TERM].each do |sig|
            trap(sig) do
              server.shutdown
            end
          end
        end
      end
    end
  end
end
