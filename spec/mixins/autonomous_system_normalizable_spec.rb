# frozen_string_literal: true

class Test
  include Mihari::Mixins::AutonomousSystemNormalizable
end

RSpec.describe Test do
  subject(:subject) { described_class.new }

  describe "#normalize_asn" do
    where(:value, :expected) do
      [
        [1, 1],
        ["1", 1],
        ["AS1", 1]
      ]
    end

    with_them do
      it do
        expect(subject.normalize_asn(value)).to eq(expected)
      end
    end
  end
end
