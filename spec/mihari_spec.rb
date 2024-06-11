# frozen_string_literal: true

RSpec.describe Mihari do
  it "has a version number" do
    expect(Mihari::VERSION).not_to be_nil
  end

  it "has a config" do
    expect(described_class.config).not_to be_nil
  end

  describe "#sidekiq?" do
    it "returns false in RSpec" do
      expect(described_class.sidekiq?).to be(false)
    end
  end

  describe "#puma?" do
    it "returns false in RSpec" do
      expect(described_class.puma?).to be(false)
    end
  end

  describe "#config" do
    describe "#retry_exponential_backoff" do
      context "with lowercase value" do
        before do
          ENV["RETRY_EXPONENTIAL_BACKOFF"] = "true"
          described_class.config.load
        end

        it do
          expect(described_class.config.retry_exponential_backoff).to be true
        end
      end

      context "with non-lowercase value" do
        before do
          ENV["RETRY_EXPONENTIAL_BACKOFF"] = "False"
          described_class.config.load
        end

        it do
          expect(described_class.config.retry_exponential_backoff).to be false
        end
      end
    end

    context "with analyzer configuration keys" do
      where(:key) do
        described_class.analyzers.map(&:configuration_keys).flatten
      end

      with_them do
        it do
          expect(described_class.config.respond_to?(key)).to be true
        end
      end
    end

    context "with emitter configuration keys" do
      where(:key) do
        described_class.emitters.map(&:configuration_keys).flatten
      end

      with_them do
        it do
          expect(described_class.config.respond_to?(key)).to be true
        end
      end
    end

    context "with enricher configuration keys" do
      where(:key) do
        described_class.enrichers.map(&:configuration_keys).flatten
      end

      with_them do
        it do
          expect(described_class.config.respond_to?(key)).to be true
        end
      end
    end
  end
end
