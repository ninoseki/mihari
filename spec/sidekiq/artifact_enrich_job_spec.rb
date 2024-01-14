# frozen_string_literal: true

RSpec.describe Mihari::Jobs::ArtifactEnrichJob do
  include_context "with faked Sidekiq configuration"

  let!(:artifact) { FactoryBot.create(:artifact, :unenrichable) }

  it do
    Sidekiq::Testing.inline! do
      expect { described_class.perform_async(artifact.id) }.to raise_error(Mihari::UnenrichableError)
    end
  end
end
