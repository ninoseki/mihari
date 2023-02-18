# frozen_string_literal: true

require "yaml"

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Initializer
end

RSpec.describe Mihari::Commands::Initializer do
  describe "#initialize_rule_yaml" do
    it do
      files = Dry::Files.new(memory: true)
      filename = "/tmp/foo.yml"
      CLI.new.initialize_rule_yaml(filename, files)

      yaml = files.read(filename)
      rule = Mihari::Structs::Rule.from_yaml(yaml)
      expect(rule.errors?).to be false
      expect(rule.data).to be_a(Hash)
    end
  end

  let(:sio) { StringIO.new }
  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Mihari"]
  end

  before { allow(Mihari).to receive(:logger).and_return(logger) }

  describe "#rule" do
    let(:path) { "/tmp/#{SecureRandom.uuid}.yml" }

    after { FileUtils.rm path }

    it do
      capture(:stderr) { CLI.start ["init", "--filename", path] }

      # read logger output
      SemanticLogger.flush
      sio.rewind
      output = sio.read

      expect(output).to include("A new rule file is initialized")
    end
  end
end
