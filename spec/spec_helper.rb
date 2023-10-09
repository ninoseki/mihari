# frozen_string_literal: true

require "bundler/setup"

require "base64"
require "digest"
require "fakefs/safe"
require "faker"
require "rack/test"
require "simplecov"
require "vcr"

require "dotenv/load"

def ci_env?
  # CI=true in GitHub Actions
  ENV["CI"]
end

# setup simplecov formatter for coveralls
class InceptionFormatter
  def format(result)
    Coveralls::SimpleCov::Formatter.new.format(result)
  end
end

def formatter
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

def setup_formatter
  if ENV["GITHUB_ACTIONS"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end
  end
  SimpleCov.formatter = formatter
end

setup_formatter

SimpleCov.start do
  add_filter do |source_file|
    source_file.filename.include?("spec") && !source_file.filename.include?("fixture")
  end
  add_filter %r{/.bundle/}
end

require "coveralls"

# for Rack app / Sinatra controllers
ENV["APP_ENV"] = "test"
# Use in-memory SQLite in local test
ENV["DATABASE_URL"] = "sqlite3:///:memory:" unless ci_env?

require "mihari"

def authorization_field(username, password)
  token = "#{username}:#{password}"
  "Basic #{Base64.strict_encode64(token)}"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_localhost = false

  api_keys = Mihari.config.keys.select { |key| key.end_with?("_API_KEY") }
  passwords = Mihari.config.keys.select { |key| key.end_with?("_PASSWORD") }
  secrets = Mihari.config.keys.select { |key| key.end_with?("_SECRET") }
  usernames = Mihari.config.keys.select { |key| key.end_with?("_USERNAME") }
  ids = Mihari.config.keys.select { |key| key.end_with?("_ID") }
  api_urls = Mihari.config.keys.select { |key| key != "DATABASE_URL" && key.end_with?("_URL") }

  (api_keys + passwords + secrets + usernames + ids).each do |key|
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

# reload dummy/sanitized config values
Mihari.config.load

# require shared recipes & shared contexts
require "test_prof/recipes/rspec/before_all"

require_relative "support/shared_contexts/database_context"
require_relative "support/shared_contexts/logger_context"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"

  config.before(:suite) do
    Mihari::Database.connect

    ActiveRecord::Migration.verbose = false
    Mihari::Database.migrate :up
  end

  config.before(:suite) do
    Mihari::Database.close
  end
end
