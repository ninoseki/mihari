# frozen_string_literal: true

require "awrence"
require "sinatra"
require "sinatra/json"

module Mihari
  module Controllers
    class ConfigController < Sinatra::Base
      get "/api/config" do
        report = Status.check

        json report.to_camelback_keys
      end
    end
  end
end
