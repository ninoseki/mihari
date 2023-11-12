require "./lib/mihari"

require "better_errors"

# set rack env as development
ENV["RACK_ENV"] ||= "development"

run Mihari::Web::App.instance
