# frozen_string_literal: true

require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "run rackup (via rerun)"
task :rackup do
  sh "rerun --pattern '{Gemfile.lock,lib/**/*.rb,lib/*.rb}' -- rackup config.ru"
end

def ci?
  ENV.fetch("CI", false)
end

unless ci?
  task :build do
    sh "./build_frontend.sh"
  end
end

# require it later enables doing pre-build step (= build the frontend app)
require "bundler/gem_tasks"
