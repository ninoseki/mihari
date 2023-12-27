# frozen_string_literal: true

class ArtifactCLI < Mihari::CLI::Base
  include Mihari::Commands::Artifact
end

RSpec.describe Mihari::Commands::Artifact do
  let_it_be(:artifact) { FactoryBot.create(:artifact, :ip) }

  describe "#list" do
    it do
      expect { ArtifactCLI.start ["list"] }.to output(include(artifact.data)).to_stdout
    end
  end

  describe "#get" do
    it do
      expect { ArtifactCLI.start ["get", artifact.id.to_s] }.to output(include(artifact.data)).to_stdout
    end
  end
end
