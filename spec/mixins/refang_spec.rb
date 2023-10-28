# frozen_string_literal: true

class Test
  include Mihari::Mixins::Refang
end

RSpec.describe Test do
  describe "#refang" do
    subject(:subject) { described_class.new }

    it do
      expect(subject.refang("1.1.1.1")).to eq("1.1.1.1")
    end

    it do
      expect(subject.refang("1.1.1[.]1")).to eq("1.1.1.1")
    end

    it do
      expect(subject.refang("1.1.1(.)1")).to eq("1.1.1.1")
    end
  end
end
