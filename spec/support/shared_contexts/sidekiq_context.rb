# frozen_string_literal: true

RSpec.shared_context "with faked Sidekiq configuration" do
  before(:all) do
    Sidekiq.configure_server do |config|
      config.redis = {url: "redis://localhost:6379"}
    end

    Sidekiq.configure_client do |config|
      config.redis = {url: "redis://localhost:6379"}
    end
  end

  after(:all) do
    Sidekiq.configure_server do |config|
      config.redis = {url: Mihari.config.sidekiq_redis_url.to_s}
    end

    Sidekiq.configure_client do |config|
      config.redis = {url: Mihari.config.sidekiq_redis_url.to_s}
    end
  end
end
