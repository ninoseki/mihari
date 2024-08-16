# frozen_string_literal: true

require "bundler/setup"

# TODO: delete after factory_bot update
require "active_support/inflector"

require "base64"
require "digest"
require "factory_bot"
require "fakefs/safe"
require "faker"
require "rack/test"
require "rspec-parameterized"
require "sidekiq/testing"
require "simplecov"
require "timecop"
require "vcr"

require "dotenv/load"

def ci_env?
  # CI=true in GitHub Actions
  ENV["CI"]
end

SimpleCov.start "rails" do
  if ENV["CI"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end

# for Rack app / Sinatra controllers
ENV["APP_ENV"] = "test"
# Use in-memory SQLite in local test
ENV["DATABASE_URL"] = "sqlite3::memory:" unless ci_env?

require "mihari"

require "mihari/cli/application"
require "mihari/web/application"

def authorization_field(username, password)
  token = "#{username}:#{password}"
  "Basic #{Base64.strict_encode64(token)}"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_localhost = true

  keys = Mihari.config.keys.map(&:upcase)
  api_keys = keys.select { |key| key.end_with?("_API_KEY") }
  passwords = keys.select { |key| key.end_with?("_PASSWORD") }
  secrets = keys.select { |key| key.end_with?("_SECRET") }
  usernames = keys.select { |key| key.end_with?("_USERNAME") }
  emails = keys.select { |key| key.end_with?("_EMAIL") }
  ids = keys.select { |key| key.end_with?("_ID") }
  api_urls = keys.select do |key|
    key != "DATABASE_URL" && key != "SIDEKIQ_REDIS_URL" && key.end_with?("_URL")
  end

  (api_keys + passwords + secrets + usernames + ids + emails).each do |key|
    ENV[key] = Digest::MD5.hexdigest(key) if ci_env? || !ENV.key?(key)
    config.filter_sensitive_data("<#{key}>") { ENV[key] }
  end

  api_urls.each do |key|
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

# NOTE: since test-prof v1.4.0, it needs to be required with the connection
Mihari::Database.with_db_connection do
  require "test_prof/recipes/rspec/let_it_be"
end

# reload dummy/sanitized config values
Mihari.config.reload

# require shared recipes & shared contexts
require_relative "support/helpers"
require_relative "support/shared_contexts/httpbin_context"
require_relative "support/shared_contexts/logger_context"
require_relative "support/shared_contexts/sidekiq_context"

require_relative "factories/alerts"
require_relative "factories/artifacts"
require_relative "factories/rules"
require_relative "factories/tags"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Spec::Support::Helpers

  config.order = "random"

  config.before(:suite) do
    Mihari::Database.connect

    ActiveRecord::Migration.verbose = false
    Mihari::Database.migrate :up
  end

  config.after(:suite) do
    Mihari::Database.close
  end
end
