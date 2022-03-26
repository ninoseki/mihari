# frozen_string_literal: true

require "yaml"

class Test
  include Mihari::Mixins::Rule
end

RSpec.describe Test do
  subject { described_class.new }

  describe "#initialize_rule_yaml" do
    it do
      files = Dry::Files.new(memory: true)
      filename = "/tmp/foo.yml"
      subject.initialize_rule_yaml(filename, files)

      yaml = files.read(filename)
      rule = Mihari::Structs::Rule::Rule.from_yaml(yaml)
      expect(rule.errors?).to eq(false)

      expect(rule.data).to be_a(Hash)
    end
  end

  describe "#load_yaml_from_db" do
    include_context "with database fixtures"

    it do
      rule = Mihari::Rule.first
      yaml = subject.load_yaml_from_db rule.id

      # Rule fixture does not have yaml data
      expect(rule.yaml).to eq(nil)
      # Then the function should return YAML based on "data"
      expect(yaml).is_a?(String)
    end
  end
end
