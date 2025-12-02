# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "mihari/version"

def ci_env?
  # CI=true in GitHub Actions
  ENV["CI"]
end

Gem::Specification.new do |spec|
  spec.name = "mihari"
  spec.version = Mihari::VERSION
  spec.authors = ["Manabu Niseki"]
  spec.email = ["manabu.niseki@gmail.com"]

  spec.summary = "A query aggregator for OSINT based threat hunting"
  spec.homepage = "https://github.com/ninoseki/mihari"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.2"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(.github|.vscode|docs|docker|frontend|images|spec|)/}) }
  end
  # Include frontend assets in lib/mihari/web/public
  spec.files += Dir.glob("lib/mihari/web/public/**/*")

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "better_errors", "~> 2.10.1"
  spec.add_development_dependency "binding_of_caller", "~> 1.0.1"
  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "capybara", "~> 3.40"
  spec.add_development_dependency "factory_bot", "~> 6.5.6"
  spec.add_development_dependency "fakefs", "~> 3.0.4"
  spec.add_development_dependency "faker", "~> 3.5.2"
  spec.add_development_dependency "fuubar", "~> 2.5.1"
  spec.add_development_dependency "mysql2", "~> 0.5.7"
  spec.add_development_dependency "pg", "~> 1.6.2"
  spec.add_development_dependency "rack-test", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.3.1"
  spec.add_development_dependency "rb-fsevent", "~> 0.11.2"
  spec.add_development_dependency "rerun", "~> 0.14"
  spec.add_development_dependency "rspec-httpbin", "~> 0.1.0"
  spec.add_development_dependency "rspec-parameterized", "~> 2.0.1"
  spec.add_development_dependency "rspec", "~> 3.13.2"
  spec.add_development_dependency "rubocop-capybara", "~> 2.22.1"
  spec.add_development_dependency "rubocop-factory_bot", "~> 2.28.0"
  spec.add_development_dependency "rubocop-rake", "~> 0.7.1"
  spec.add_development_dependency "rubocop-rspec", "~> 3.8.0"
  spec.add_development_dependency "rubocop-yard", "~> 1.0.0"
  spec.add_development_dependency "simplecov-lcov", "~> 0.9.0"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "standard", "~> 1.52.0"
  spec.add_development_dependency "test-prof", "~> 1.4.4"
  spec.add_development_dependency "timecop", "~> 0.9.10"
  spec.add_development_dependency "vcr", "~> 6.3.1"
  spec.add_development_dependency "webmock", "~> 3.26.1"

  unless ci_env?
    spec.add_development_dependency "lefthook", "~> 2.0.4"
    spec.add_development_dependency "ruby-lsp-rspec", "~> 0.1.28"
    spec.add_development_dependency "solargraph", "~> 0.57.0"
  end

  spec.add_dependency "activerecord", "8.1.1"
  spec.add_dependency "addressable", "~> 2.8"
  spec.add_dependency "anyway_config", "2.7.2"
  spec.add_dependency "awrence", "4.0.0"
  spec.add_dependency "csv", "~> 3.3"
  spec.add_dependency "dotenv", "3.1.8"
  spec.add_dependency "dry-container", "0.11.0"
  spec.add_dependency "dry-files", "1.1.0"
  spec.add_dependency "dry-monads", "1.9.0"
  spec.add_dependency "dry-schema", "1.14.1"
  spec.add_dependency "dry-struct", "1.8.0"
  spec.add_dependency "dry-validation", "1.11.1"
  spec.add_dependency "email_address", "0.2.7"
  spec.add_dependency "grape", "3.0.1"
  spec.add_dependency "grape-entity", "1.0.1"
  spec.add_dependency "grape-swagger", "2.1.3"
  spec.add_dependency "grape-swagger-entity", "0.7.0"
  spec.add_dependency "http", "5.3.1"
  spec.add_dependency "jbuilder", "2.14.1"
  spec.add_dependency "jr-cli", "0.6.0"
  spec.add_dependency "launchy", "3.1.1"
  spec.add_dependency "memo_wise", "1.13.0"
  spec.add_dependency "normalize_country", "0.3.3"
  spec.add_dependency "parallel", "1.27.0"
  spec.add_dependency "plissken", "4.0.0"
  spec.add_dependency "public_suffix", "7.0.0"
  spec.add_dependency "puma", "7.1.0"
  spec.add_dependency "rack", "3.2.4"
  spec.add_dependency "rack-cors", "3.0.0"
  spec.add_dependency "rack-session", "2.1.1"
  spec.add_dependency "rackup", "2.2.1"
  spec.add_dependency "search_cop", "1.4.1"
  spec.add_dependency "semantic_logger", "4.17.0"
  spec.add_dependency "sentry-ruby", "6.2.0"
  spec.add_dependency "sentry-sidekiq", "6.2.0"
  spec.add_dependency "sidekiq", "8.0.10"
  spec.add_dependency "slack-notifier", "2.4.0"
  spec.add_dependency "sqlite3", "~> 2.7"
  spec.add_dependency "thor", "1.4.0"
  spec.add_dependency "thor-hollaback", "0.2.1"
  spec.add_dependency "tilt", "2.6.1"
  spec.add_dependency "tilt-jbuilder", "0.7.1"
  spec.add_dependency "uuidtools", "3.0.0"
  spec.add_dependency "whois", "6.0.3"
  spec.add_dependency "whois-parser", "2.0.0"
end
