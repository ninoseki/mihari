# frozen_string_literal: true

RSpec.describe Mihari::Jobs::ArtifactEnrichJob do
  include_context "with faked Sidekiq configuration"

  let!(:artifact) { FactoryBot.create(:artifact, :mail) }

  it do
    Sidekiq::Testing.inline! do
      res = described_class.perform_async(artifact.id)
      expect(res).not_to be nil
    end
  end
end
