# frozen_string_literal: true

require "bundler/setup"

require "base64"
require "fakefs/safe"
require "vcr"
require "digest"

require "simplecov"
require "coveralls"

Coveralls.wear!

def ci_env?
  # CI=true and TRAVIS=true in Travis CI
  ENV["CI"] || ENV["TRAVIS"]
end

# Use in-memory SQLite in local test
unless ci_env?
  ENV["DATABASE"] = ":memory:"
end

require_relative "./support/helpers/helpers"
require_relative "./support/shared_contexts/database_context"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Spec::Support::Helpers
  config.include_context "with database"
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

  api_keys = %w[
    THEHIVE_API_KEY
    MISP_API_KEY
    CENSYS_AUTH CENSYS_ID CENSYS_SECRET
    SHODAN_API_KEY
    ONYPHE_API_KEY
    VIRUSTOTAL_API_KEY
    SECURITYTRAILS_API_KEY
    ZOOMEYE_API_KEY
    BINARYEDGE_API_KEY
    PULSEDIVE_API_KEY
    OTX_API_KEY
    SPYSE_API_KEY
    URLSCAN_API_KEY
    CIRCL_PASSIVE_USERNAME
    CIRCL_PASSIVE_PASSWORD
    PASSIVETOTAL_USERNAME
    PASSIVETOTAL_API_KEY
  ]

  api_endpoints = %w[
    THEHIVE_API_ENDPOINT
    MISP_API_ENDPOINT
    WEBHOOK_URL
  ]

  api_keys.each do |key|
    ENV[key] = Digest::MD5.hexdigest(key) unless ENV.key?(key)
    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end

  api_endpoints.each do |key|
    ENV[key] = "http://#{Digest::MD5.hexdigest(key)}"
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
end

# load Mihari after modifying ENV values
require "mihari"
