# frozen_string_literal: true

require "time"

require "rspec/core/rake_task"
require "rubocop/rake_task"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Run rackup (with rerun)"
task :rackup do
  sh "rerun --pattern '{Gemfile.lock,lib/**/*.rb,lib/*.rb}' -- rackup config.ru"
end

def recursive_delete(hash, to_remove)
  hash.delete(to_remove)
  hash.each_value do |value|
    recursive_delete(value, to_remove) if value.is_a? Hash
  end
end

def build_swagger_doc(path)
  require_relative "lib/mihari"
  require_relative "lib/mihari/web/application"

  require "rack/test"

  app = Mihari::Web::App.new
  session = Rack::Test::Session.new(app)

  res = session.request("/api/swagger_doc")

  json = JSON.parse(res.body.to_s)
  # remove host because it can be varied
  keys_to_remove = %w[host]
  keys_to_remove.each do |key|
    recursive_delete json, key
  end

  File.write(path, json.to_yaml)
end

namespace :build do
  desc "Build Swagger doc"
  task :swagger, [:path] do |_t, args|
    args.with_defaults(path: "./frontend/swagger.yaml")

    started_at = Time.now
    build_swagger_doc args.path
    elapsed = (Time.now - started_at).floor(2)

    puts "Swagger doc is built in #{elapsed}s"
  end

  desc "Build frontend assets"
  task :frontend do
    # Build frontend assets
    sh "cd frontend && npm install && npm run docs && npm run build-only"
    # Copy built assets into ./lib/web/public/
    sh "rm -rf ./lib/mihari/web/public/"
    sh "mkdir -p ./lib/mihari/web/public/"
    sh "cp -r frontend/dist/* ./lib/mihari/web/public"
  end

  def latest_tag
    `git describe --tags --abbrev=0`.strip.sub(/^v/, "")
  end

  desc "Build version file"
  task :version do
    File.write("lib/mihari/version.rb", <<~RUBY)
      module Mihari
        VERSION = "#{latest_tag}"
      end
    RUBY
  end
end

desc "Build including Swagger doc and frontend assets"
task :build do
  Rake::Task["build:swagger"].invoke
  Rake::Task["build:frontend"].invoke
  Rake::Task["build:version"].invoke
end

# require it later enables doing pre-build step (= build the frontend app)
require "bundler/gem_tasks"

Rake::Task["release:guard_clean"].clear

# Disable tagging for `rake release`
namespace :release do
  # allow dynamic versioning (updating version.rb) without committing
  task :guard_clean do
    puts "Overriding guard_clean task"
  end
end
