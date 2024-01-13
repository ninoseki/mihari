# frozen_string_literal: true

RSpec.describe Mihari::Services::FeedReader do
  describe "#read" do
    context "with CSV file" do
      let!(:uri) { "file://#{File.expand_path("../fixtures/feed/test.csv", __dir__)}" }

      it do
        data = described_class.call(uri)
        expect(data).to be_an(Array)
      end
    end

    context "with JSON file" do
      let!(:uri) { "file://#{File.expand_path("../fixtures/feed/test.json", __dir__)}" }

      it do
        data = described_class.call(uri)
        expect(data).to be_an(Hash)
      end
    end
  end
end
