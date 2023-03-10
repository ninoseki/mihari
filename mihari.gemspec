# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mihari/version"

Gem::Specification.new do |spec|
  spec.name = "mihari"
  spec.version = Mihari::VERSION
  spec.authors = ["Manabu Niseki"]
  spec.email = ["manabu.niseki@gmail.com"]

  spec.summary = "A framework for continuous OSINT based threat hunting"
  spec.homepage = "https://github.com/ninoseki/mihari"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "coveralls_reborn", "~> 0.27"
  spec.add_development_dependency "fakefs", "~> 2.4"
  spec.add_development_dependency "fuubar", "~> 2.5"
  spec.add_development_dependency "mysql2", "~> 0.5"
  spec.add_development_dependency "overcommit", "~> 0.60"
  spec.add_development_dependency "pg", "~> 1.4"
  spec.add_development_dependency "rack-test", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rb-fsevent", "~> 0.11"
  spec.add_development_dependency "rerun", "~> 0.14"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "ruby-lsp", "~> 0.4"
  spec.add_development_dependency "simplecov-lcov", "~> 0.8.0"
  spec.add_development_dependency "standard", "~> 1.24"
  spec.add_development_dependency "steep", "~> 1.3"
  spec.add_development_dependency "timecop", "~> 0.9"
  spec.add_development_dependency "vcr", "~> 6.1"
  spec.add_development_dependency "webmock", "~> 3.18"

  spec.add_dependency "activerecord", "7.0.4.2"
  spec.add_dependency "addressable", "2.8.1"
  spec.add_dependency "awrence", "2.0.1"
  spec.add_dependency "censysx", "0.1.1"
  spec.add_dependency "dnpedia", "0.1.0"
  spec.add_dependency "dotenv", "2.8.1"
  spec.add_dependency "dry-configurable", "1.0.1"
  spec.add_dependency "dry-container", "0.11.0"
  spec.add_dependency "dry-files", "1.0.1"
  spec.add_dependency "dry-initializer", "3.1.1"
  spec.add_dependency "dry-schema", "1.13.0"
  spec.add_dependency "dry-struct", "1.6.0"
  spec.add_dependency "dry-validation", "1.10.0"
  spec.add_dependency "email_address", "0.2.4"
  spec.add_dependency "grape", "1.7.0"
  spec.add_dependency "grape-entity", "1.0.0"
  spec.add_dependency "grape-swagger", "1.5.0"
  spec.add_dependency "grape-swagger-entity", "0.5.1"
  spec.add_dependency "greynoise", "0.1.1"
  spec.add_dependency "hachi", "2.0.0"
  spec.add_dependency "insensitive_hash", "0.3.3"
  spec.add_dependency "jr-cli", "0.6.0"
  spec.add_dependency "launchy", "2.5.2"
  spec.add_dependency "memist", "2.0.2"
  spec.add_dependency "misp", "0.1.4"
  spec.add_dependency "net-ping", "2.0.8"
  spec.add_dependency "normalize_country", "0.3.2"
  spec.add_dependency "onyphe", "2.0.0"
  spec.add_dependency "parallel", "1.22.1"
  spec.add_dependency "passive_circl", "0.1.0"
  spec.add_dependency "passivetotalx", "0.1.1"
  spec.add_dependency "plissken", "2.0.1"
  spec.add_dependency "public_suffix", "5.0.1"
  spec.add_dependency "puma", "6.0.2"
  spec.add_dependency "rack", "2.2.4"
  spec.add_dependency "rack-contrib", "2.3.0"
  spec.add_dependency "rack-cors", "1.1.1"
  spec.add_dependency "securitytrails", "1.0.0"
  spec.add_dependency "semantic_logger", "4.12.0"
  spec.add_dependency "sentry-ruby", "5.7.0"
  spec.add_dependency "shodanx", "0.2.1"
  spec.add_dependency "slack-notifier", "2.4.0"
  spec.add_dependency "sqlite3", "1.6.0"
  spec.add_dependency "thor", "1.2.1"
  spec.add_dependency "urlscan", "0.8.0"
  spec.add_dependency "uuidtools", "2.2.0"
  spec.add_dependency "virustotalx", "1.2.0"
  spec.add_dependency "whois", "5.1.0"
  spec.add_dependency "whois-parser", "2.0.0"
end
