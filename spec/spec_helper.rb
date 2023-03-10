# frozen_string_literal: true

require "bundler/setup"

require "base64"
require "digest"
require "fakefs/safe"
require "rack/test"
require "vcr"

require "dotenv/load"

require "simplecov"

class InceptionFormatter
  def format(result)
    Coveralls::SimpleCov::Formatter.new.format(result)
  end
end

def setup_formatter
  if ENV["GITHUB_ACTIONS"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end
  end

  SimpleCov.formatter =
    if ENV["CI"] || ENV["COVERALLS_REPO_TOKEN"]
      if ENV["GITHUB_ACTIONS"]
        SimpleCov::Formatter::MultiFormatter.new([InceptionFormatter, SimpleCov::Formatter::LcovFormatter])
      else
        InceptionFormatter
      end
    else
      SimpleCov::Formatter::HTMLFormatter
    end
end

setup_formatter

SimpleCov.start do
  add_filter do |source_file|
    source_file.filename.include?("spec") && !source_file.filename.include?("fixture")
  end
  add_filter %r{/.bundle/}
end

require "coveralls"

def ci_env?
  # CI=true and TRAVIS=true in Travis CI
  ENV["CI"] || ENV["TRAVIS"]
end

# Use in-memory SQLite in local test
ENV["DATABASE_URL"] = "sqlite3:///:memory:" unless ci_env?

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
    IPINFO_API_KEY
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
    GREYNOISE_API_KEY
    THREATFOX_API_KEY
  ]

  api_endpoints = %w[
    THEHIVE_API_ENDPOINT
    THEHIVE_URL
    MISP_API_ENDPOINT
    MISP_URL
    WEBHOOK_URL
  ]

  api_keys.each do |key|
    ENV[key] = Digest::MD5.hexdigest(key) if ci_env? || !ENV.key?(key)

    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end

  api_endpoints.each do |key|
    ENV[key] = "http://#{Digest::MD5.hexdigest(key)}" if ci_env? || !ENV.key?(key)
    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end

  # Censys
  config.filter_sensitive_data("<CENSYS_AUTH>") do
    authorization_field ENV["CENSYS_ID"] || "foo", ENV["CENSYS_SECRET"] || "bar"
  end
  # CIRCL
  config.filter_sensitive_data("<CIRCL_AUTH>") do
    authorization_field ENV["CIRCL_PASSIVE_USERNAME"] || "foo", ENV["CIRCL_PASSIVE_PASSWORD"] || "bar"
  end
  # PassiveTotal
  config.filter_sensitive_data("<PASSIVETOTAL_AUTH>") do
    authorization_field ENV["PASSIVETOTAL_USERNAME"] || "foo", ENV["PASSIVETOTAL_API_KEY"] || "bar"
  end
end

# for Rack app / Sinatra controllers
ENV["APP_ENV"] = "test"

# load Mihari after modifying ENV values
require "mihari"

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

  config.before(:example) do
    Mihari::Database.connect

    ActiveRecord::Migration.verbose = false
    Mihari::Database.migrate :up
  end

  config.after(:example) do
    Mihari::Database.migrate :down

    Mihari::Database.close
  end
end
