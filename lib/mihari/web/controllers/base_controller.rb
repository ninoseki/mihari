# frozen_string_literal: true

require "rack/contrib/json_body_parser"
require "sinatra"
require "sinatra/param"

module Mihari
  module Controllers
    class BaseController < Sinatra::Base
      helpers Sinatra::Param

      use Rack::JSONBodyParser

      set :show_exceptions, false
      set :raise_sinatra_param_exceptions, true

      error Sinatra::Param::InvalidParameterError do
        json({ error: "#{env['sinatra.error'].param} is invalid" })
      end
    end
  end
end
