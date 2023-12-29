# frozen_string_literal: true

class RefangTest
  include Mihari::Concerns::Refangable
end

RSpec.describe Mihari::Concerns::Refangable do
  describe "#refang" do
    subject(:subject) { RefangTest.new }

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
