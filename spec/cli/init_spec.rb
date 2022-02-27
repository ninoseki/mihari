# frozen_string_literal: true

require "fileutils"
require "securerandom"

RSpec.describe Mihari::CLI::Initialization do
  subject { described_class }

  let(:sio) { StringIO.new }
  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Mihari"]
  end

  describe "#rule" do
    let(:path) { "/tmp/#{SecureRandom.uuid}.yml" }

    before { allow(Mihari).to receive(:logger).and_return(logger) }

    after do
      FileUtils.rm path
    end

    it do
      capture(:stderr) { subject.start ["rule", "--filename", path] }

      # read logger output
      SemanticLogger.flush
      sio.rewind
      output = sio.read

      expect(output).to include("The rule file is initialized")
    end
  end
end
