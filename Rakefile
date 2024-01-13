# frozen_string_literal: true

require "time"

require "rspec/core/rake_task"
require "standard/rake"

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

  f = File.open(path, "w")
  f.write json.to_yaml
  f.close
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
end

task :build do
  Rake::Task["build:swagger"].invoke

  # Build ReDocs docs & frontend assets
  sh "cd frontend && npm install && npm run docs && npm run build-only"
  # Copy built assets into ./lib/web/public/
  sh "rm -rf ./lib/mihari/web/public/"
  sh "mkdir -p ./lib/mihari/web/public/"
  sh "cp -r frontend/dist/* ./lib/mihari/web/public"
end

# require it later enables doing pre-build step (= build the frontend app)
require "bundler/gem_tasks"
