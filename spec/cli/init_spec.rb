# frozen_string_literal: true

require "fileutils"
require "securerandom"

RSpec.describe Mihari::CLI::Initialization do
  subject { described_class }

  describe "#config" do
    let(:path) { "/tmp/#{SecureRandom.uuid}.yml" }

    after do
      FileUtils.rm path
    end

    it do
      output = capture(:stdout) { subject.start ["config", "--filename", path] }
      expect(output).to include("The config file is initialized")
    end
  end

  describe "#rule" do
    let(:path) { "/tmp/#{SecureRandom.uuid}.yml" }

    after do
      FileUtils.rm path
    end

    it do
      output = capture(:stdout) { subject.start ["rule", "--filename", path] }
      expect(output).to include("The rule file is initialized")
    end
  end
end
