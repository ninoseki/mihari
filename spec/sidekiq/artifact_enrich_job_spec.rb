RSpec.describe Mihari::Jobs::ArtifactEnrichJob do
  let!(:artifact) { FactoryBot.create(:artifact) }

  before { allow(artifact).to receive(:enrich_all).and_return(nil) }

  it do
    Sidekiq::Testing.inline! do
      res = described_class.perform_async(artifact.id)
      expect(res).not_to be nil
    end
  end
end
