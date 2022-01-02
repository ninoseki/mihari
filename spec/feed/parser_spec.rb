# frozen_string_literal: true

RSpec.describe Mihari::Feed::Parser do
  subject { described_class.new data }

  let(:data) {
    [{
      a: ["a", "b", "c"],
      b: [{ foo: "bar", bar: "foo" }, { foo: "foo", bar: "bar" }],
      c: [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
    }]
  }

  describe "#parse" do
    it do
      parsed = subject.parse "map(&:a).unwrap"
      expect(parsed).to eq(["a", "b", "c"])
    end

    it do
      parsed = subject.parse "map(&:b).unwrap.map(&:foo)"
      expect(parsed).to eq(["bar", "foo"])
    end

    it do
      parsed = subject.parse "map(&:c).unwrap.map { |v| v[1] }"
      expect(parsed).is_a?(Array)
      expect(parsed).to eq(["2", "5", "8"])
    end
  end
end
