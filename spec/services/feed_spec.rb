RSpec.describe Mihari::Services::FeedParser do
  let!(:data) do
    {
      a: %w[a b c],
      b: [{ foo: "bar", bar: "foo" }, { foo: "foo", bar: "bar" }],
      c: [%w[1 2 3], %w[4 5 6], %w[7 8 9]]
    }
  end

  describe "#call" do
    where(:selector, :expected) do
      [
        ["a", %w[a b c]],
        ["b.map(&:foo)", %w[bar foo]],
        ["c.map { |v| v[1] }", %w[2 5 8]]
      ]
    end

    with_them do
      it do
        parsed = described_class.call(data, selector)
        expect(parsed).to eq(expected)
      end
    end
  end
end

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
