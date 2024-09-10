# frozen_string_literal: true

require "sidekiq"

require "mihari/sidekiq/jobs"

Sidekiq.configure_server do |config|
  config.redis = {url: Mihari.config.sidekiq_redis_url.to_s}
  config.default_job_options = {retry: Mihari.config.sidekiq_retry}
end

Sidekiq.configure_client do |config|
  config.redis = {url: Mihari.config.sidekiq_redis_url.to_s}
end
