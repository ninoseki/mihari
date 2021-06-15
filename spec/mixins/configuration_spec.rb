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

      expect(data.is_a?(Hash)).to eq(true)
    end
  end
end
