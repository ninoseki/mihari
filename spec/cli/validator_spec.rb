# frozen_string_literal: true

require "stringio"

RSpec.describe Mihari::CLI::Validator do
  subject { described_class }

  let(:sio) { StringIO.new }
  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Mihari"]
  end

  describe "#rule" do
    before { allow(Mihari).to receive(:logger).and_return(logger) }

    let(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }

    it do
      capture(:stderr) { subject.start ["rule", path] }

      # read logger output
      SemanticLogger.flush
      sio.rewind
      output = sio.read

      expect(output).to include("Valid format.")
    end

    context "with invalid rule" do
      let(:path) { File.expand_path("../fixtures/rules/invalid_rule.yml", __dir__) }

      it do
        subject.start ["rule", path]

        # read logger output
        SemanticLogger.flush
        sio.rewind
        output = sio.read

        expect(output).to include("Failed to parse")
      end
    end
  end
end
