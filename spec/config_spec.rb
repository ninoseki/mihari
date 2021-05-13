# frozen_string_literal: true

RSpec.describe Mihari do
  subject { described_class }

  describe ".load_from_yaml" do
    it do
      path = File.expand_path("./fixtures/test.yml", __dir__)
      described_class.load_config_from_yaml path

      expect(Mihari.config.virustotal_api_key).to eq("foo bar")
    end
  end
end
