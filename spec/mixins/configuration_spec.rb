# frozen_string_literal: true

class Test
  include Mihari::Mixins::Configuration
end

RSpec.describe Test do
  subject { described_class.new }

  describe "#initialize_config_yaml" do
    it do
      files = Dry::Files.new(memory: true)
      filename = "/tmp/foo.yml"
      subject.initialize_config_yaml(filename, files)

      data = YAML.safe_load(files.read(filename))

      expect(data).to be_a(Hash)
    end
  end

  describe "#validate_config" do
    let(:config) { { virustotal_api_key: "foo" } }

    it do
      output = capture(:stdout) { expect(subject.validate_config(config)) }
      expect(output).to eq("")
    end

    context "with invalid key" do
      let(:config) { { foo: "bar" } }

      it do
        capture(:stdout) do
          expect { expect(subject.validate_config(config)) }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "#load_config" do
    let(:path) { File.expand_path("../fixtures/configs/valid_config.yml", __dir__) }

    it do
      data = subject.load_config(path)
      expect(data).to be_a(Hash)
    end

    context "with invalid path" do
      it do
        capture(:stdout) do
          expect { subject.load_config("/tmp/foo/bar/404.yaml") }.to raise_error(Mihari::FileNotFoundError)
        end
      end
    end
  end
end
