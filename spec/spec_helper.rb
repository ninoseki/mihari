# frozen_string_literal: true

require "bundler/setup"

require "base64"
require "fakefs/safe"
require "timecop"
require "vcr"

require "simplecov"
require "coveralls"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "/spec"
end
Coveralls.wear!

# Set database url for test
ENV["DATABASE"] = ":memory:"

require "mihari"

require_relative "./support/helpers/helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Spec::Support::Helpers
end

def authorization_field(username, password)
  token = "#{username}:#{password}"
  "Basic #{Base64.strict_encode64(token)}"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_localhost = false

  api_keys = %w(
    THEHIVE_API_KEY
    MISP_API_KEY
    CENSYS_AUTH CENSYS_ID CENSYS_SECRET
    SHODAN_API_KEY
    ONYPHE_API_KEY
    VIRUSTOTAL_API_KEY
    SECURITYTRAILS_API_KEY
    ZOOMEYE_USERNAME
    ZOOMEYE_PASSWORD
    BINARYEDGE_API_KEY
    PULSEDIVE_API_KEY
  )

  api_endpoints = %w(
    THEHIVE_API_ENDPOINT
    MISP_API_ENDPOINT
  )

  api_keys.each do |key|
    ENV[key] = "foo bar" unless ENV.key?(key)
    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end

  api_endpoints.each do |key|
    ENV[key] = "http://localhost" unless ENV.key?(key)
    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end

  # Censys
  config.filter_sensitive_data("<CENSYS_AUTH>") {
    authorization_field ENV["CENSYS_ID"] || "foo", ENV["CENSYS_SECRET"] || "bar"
  }
  # CIRCL
  config.filter_sensitive_data("<CIRCL_AUTH>") {
    authorization_field ENV["CIRCL_PASSIVE_USERNAME"] || "foo", ENV["CIRCL_PASSIVE_PASSWORD"] || "bar"
  }
  # PassiveTotal
  config.filter_sensitive_data("<PASSIVETOTAL_AUTH>") {
    authorization_field ENV["PASSIVETOTAL_USERNAME"] || "foo", ENV["PASSIVETOTAL_API_KEY"] || "bar"
  }
  Mihari.config.load_from_env
end
