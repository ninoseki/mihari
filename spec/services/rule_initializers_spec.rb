# frozen_string_literal: true

RSpec.describe Mihari::Services::RuleInitializer do
  describe "#call" do
    let!(:files) { Dry::Files.new(memory: true) }
    let!(:filename) { "/tmp/foo.yml" }

    it do
      described_class.call(filename, files)

      yaml = files.read(filename)
      rule = Mihari::Rule.from_yaml(yaml)
      expect(rule.errors?).to be false
      expect(rule.data).to be_a(Hash)
    end
  end
end
