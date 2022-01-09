# frozen_string_literal: true

RSpec.describe Mihari::Feed::Reader do
  describe "#read" do
    context "with csv file" do
      let(:uri) { "file://#{File.expand_path("../fixtures/feed/test.csv", __dir__)}" }

      it do
        reader = described_class.new(uri)
        expect(reader.read).to be_an(Array)
      end
    end

    context "with JSON file" do
      let(:uri) { "file://#{File.expand_path("../fixtures/feed/test.json", __dir__)}" }

      it do
        reader = described_class.new(uri)
        expect(reader.read).to be_an(Array)
      end
    end
  end
end
