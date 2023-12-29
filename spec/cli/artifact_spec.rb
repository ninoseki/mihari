# frozen_string_literal: true

RSpec.describe Mihari::CLI::Artifact do
  let_it_be(:artifact) { FactoryBot.create(:artifact, :ip) }

  describe "#list" do
    it do
      expect { described_class.start ["list"] }.to output(include(artifact.data)).to_stdout
    end
  end

  describe "#get" do
    it do
      expect { described_class.start ["get", artifact.id.to_s] }.to output(include(artifact.data)).to_stdout
    end
  end
end
