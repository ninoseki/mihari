# frozen_string_literal: true

class ConfigurableTest
  include Mihari::Mixins::Configurable

  attr_reader :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  def configuration_keys
    %w[shodan_api_key]
  end
end

RSpec.describe ConfigurableTest do
  describe "#configured?" do
    before do
      allow(Mihari.config).to receive(:shodan_api_key).and_return(nil)
    end

    it do
      instance = described_class.new(nil)
      expect(instance.configured?).to eq(false)
    end

    it do
      instance = described_class.new("foo")
      expect(instance.configured?).to eq(true)
    end
  end
end
