# frozen_string_literal: true

RSpec.describe Mihari::Feed::Parser do
  subject(:parser) { described_class.new data }

  let!(:data) do
    [{
      a: %w[a b c],
      b: [{ foo: "bar", bar: "foo" }, { foo: "foo", bar: "bar" }],
      c: [%w[1 2 3], %w[4 5 6], %w[7 8 9]]
    }]
  end

  describe "#parse" do
    it do
      parsed = parser.parse "map(&:a).unwrap"
      expect(parsed).to eq(%w[a b c])
    end

    it do
      parsed = parser.parse "map(&:b).unwrap.map(&:foo)"
      expect(parsed).to eq(%w[bar foo])
    end

    it do
      parsed = parser.parse "map(&:c).unwrap.map { |v| v[1] }"
      expect(parsed).is_a?(Array)
      expect(parsed).to eq(%w[2 5 8])
    end
  end
end
