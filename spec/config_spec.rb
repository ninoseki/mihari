# frozen_string_literal: true

RSpec.describe Mihari.config do
  describe "#retry_exponential_backoff" do
    context "with lowercase value" do
      before do
        ENV["RETRY_EXPONENTIAL_BACKOFF"] = "true"
        Mihari.config.load
      end

      it do
        expect(Mihari.config.retry_exponential_backoff).to be true
      end
    end

    context "with non-lowercase value" do
      before do
        ENV["RETRY_EXPONENTIAL_BACKOFF"] = "False"
        Mihari.config.load
      end

      it do
        expect(Mihari.config.retry_exponential_backoff).to be false
      end
    end
  end

  context "with analyzer configuration keys" do
    where(:key) do
      Mihari.analyzers.map { |klass| klass.new("dummy").configuration_keys }.flatten
    end

    with_them do
      it do
        expect(Mihari.config.respond_to?(key)).to be true
      end
    end
  end

  context "with emitter configuration keys" do
    where(:key) do
      Mihari.emitters.map { |klass| klass.new(rule: nil).configuration_keys }.flatten
    end

    with_them do
      it do
        expect(Mihari.config.respond_to?(key)).to be true
      end
    end
  end

  context "with enricher configuration keys" do
    where(:key) do
      Mihari.enrichers.map { |klass| klass.new.configuration_keys }.flatten
    end

    with_them do
      it do
        expect(Mihari.config.respond_to?(key)).to be true
      end
    end
  end
end
