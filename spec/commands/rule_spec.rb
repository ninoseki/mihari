# frozen_string_literal: true

require "yaml"

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Rule
end

RSpec.describe Mihari::Commands::Rule do
  let(:sio) { StringIO.new }
  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Mihari"]
  end

  before { allow(Mihari).to receive(:logger).and_return(logger) }

  describe "#initialize_rule" do
    it do
      files = Dry::Files.new(memory: true)
      filename = "/tmp/foo.yml"
      CLI.new.initialize_rule(filename, files)

      yaml = files.read(filename)
      rule = Mihari::Structs::Rule.from_yaml(yaml)
      expect(rule.errors?).to be false
      expect(rule.data).to be_a(Hash)
    end
  end

  describe "#rule" do
    let(:path) { "/tmp/#{SecureRandom.uuid}.yml" }

    after { FileUtils.rm path }

    it do
      capture(:stderr) { CLI.start ["init", path] }

      # read logger output
      SemanticLogger.flush
      sio.rewind
      output = sio.read

      expect(output).to include("A new rule is initialized")
    end
  end

  describe "#validate" do
    let(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }

    it do
      capture(:stderr) { CLI.start ["validate", path] }

      # read logger output
      SemanticLogger.flush
      sio.rewind
      output = sio.read

      expect(output).to include("Valid format.")
    end

    context "with invalid rule" do
      let(:path) { File.expand_path("../fixtures/rules/invalid_rule.yml", __dir__) }

      it do
        CLI.start ["validate", path]

        # read logger output
        SemanticLogger.flush
        sio.rewind
        output = sio.read

        expect(output).to include("Failed to parse")
      end
    end
  end
end
