# frozen_string_literal: true

RSpec.describe Mihari::TagSerializer do
  let(:tag) { Mihari::Tag.new(name: "foo") }

  describe "#as_json" do
    it do
      json = described_class.new(tag).as_json
      expect(json).to eq({name: "foo"})
    end
  end
end
