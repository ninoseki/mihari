# frozen_string_literal: true

class Test
  include Mihari::Mixins::Refang
end

RSpec.describe Test do
  describe "#refang" do
    subject(:subject) { described_class.new }

    where(:value, :expected) do
      [
        ["1.1.1.1", "1.1.1.1"],
        ["1.1.1[.]1", "1.1.1.1"],
        ["1.1.1(.)1", "1.1.1.1"]
      ]
    end

    with_them do
      it do
        expect(subject.refang(value)).to eq(expected)
      end
    end
  end
end
