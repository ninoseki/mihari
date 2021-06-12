# frozen_string_literal: true

require "yaml"

RSpec.describe Mihari do
  subject { described_class }

  describe ".load_from_yaml" do
    before do
      # memo VT API key
      @virustotal_api_key = Mihari.config.virustotal_api_key
    end

    after do
      # restore VT API key
      Mihari.config.virustotal_api_key = @virustotal_api_key
    end

    it do
      path = File.expand_path("./fixtures/valid_config.yml", __dir__)
      described_class.load_config_from_yaml path

      expect(Mihari.config.virustotal_api_key).to eq("foo bar")
    end

    context "with invalid config" do
      it do
        path = File.expand_path("./fixtures/invalid_config.yml", __dir__)
        output = capture(:stdout) { described_class.load_config_from_yaml path }

        expect(Mihari.config.virustotal_api_key).to eq(nil)
        expect(output).to include("- virustotal_api_key must be a string")
      end
    end
  end

  describe ".initialize_config_yaml" do
    it do
      files = Dry::Files.new(memory: true)
      filename = "/tmp/foo.yml"
      Mihari.initialize_config_yaml(filename, files)

      data = YAML.safe_load(files.read(filename))
      Mihari.config.values.each_key do |key|
        expect(data).to have_key(key.to_s)
      end
    end
  end
end
