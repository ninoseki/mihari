# frozen_string_literal: true

RSpec.describe Mihari do
  it "has a version number" do
    expect(Mihari::VERSION).not_to be nil
  end

  describe ".load_config_from_yaml" do
    before do
      # memo VT API key
      @virustotal_api_key = Mihari.config.virustotal_api_key
    end

    after do
      # restore VT API key
      Mihari.config.virustotal_api_key = @virustotal_api_key
    end

    it do
      path = File.expand_path("./fixtures/configs/valid_config.yml", __dir__)
      described_class.load_config_from_yaml path

      expect(Mihari.config.virustotal_api_key).to eq("foo bar")
    end

    context "with invalid config" do
      it do
        path = File.expand_path("./fixtures/configs/invalid_config.yml", __dir__)
        output = capture(:stdout) do
          expect { described_class.load_config_from_yaml(path) }.to raise_error(ArgumentError)
        end

        expect(output).to include("- virustotal_api_key must be a string")
      end
    end
  end
end
