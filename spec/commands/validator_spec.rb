# frozen_string_literal: true

require "stringio"

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Validator
end

RSpec.describe Mihari::Commands::Validator do
  let(:sio) { StringIO.new }
  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Mihari"]
  end

  before { allow(Mihari).to receive(:logger).and_return(logger) }

  describe "#validate" do
    let(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }

    it do
      capture(:stderr) { CLI.start ["validate", path] }

      # read logger output
      SemanticLogger.flush
      sio.rewind
      output = sio.read

      p output

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
