# frozen_string_literal: true

require "bundler/setup"

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

def authorization_field
  require "base64"
  token = "#{ENV['CENSYS_ID']}:#{ENV['CENSYS_SECRET']}"
  "Basic #{Base64.strict_encode64(token)}"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_localhost = false

  keys = %w(
    THEHIVE_API_KEY THEHIVE_API_ENDPOINT
    MISP_API_KEY MISP_API_ENDPOINT
    CENSYS_AUTH CENSYS_ID CENSYS_SECRET
    SHODAN_API_KEY
    ONYPHE_API_KEY
    VIRUSTOTAL_API_KEY
    SECURITYTRAILS_API_KEY
  )

  keys.each do |key|
    config.filter_sensitive_data("<#{key}>") { ENV.fetch(key, "http://localhost") }
  end

  # Censys
  config.filter_sensitive_data("<CENSYS_AUTH>") { authorization_field }
end
