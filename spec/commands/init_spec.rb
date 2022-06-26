# frozen_string_literal: true

require "yaml"

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Initialization
end

RSpec.describe Mihari::Commands::Initialization do
  subject { CLI.new }

  describe "#initialize_rule_yaml" do
    it do
      files = Dry::Files.new(memory: true)
      filename = "/tmp/foo.yml"
      subject.initialize_rule_yaml(filename, files)

      yaml = files.read(filename)
      rule = Mihari::Structs::Rule.from_yaml(yaml)
      expect(rule.errors?).to eq(false)
      expect(rule.data).to be_a(Hash)
    end
  end
end
