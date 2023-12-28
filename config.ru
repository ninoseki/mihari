$LOAD_PATH.unshift("#{__dir__}/../lib")

require "mihari"
require "mihari/web/application"

require "better_errors"

ENV["APP_ENV"] ||= "development"

run Mihari::Web::App.instance
