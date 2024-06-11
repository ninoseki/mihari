# frozen_string_literal: true

class AutonomousSystemTest
  include Mihari::Concerns::AutonomousSystemNormalizable
end

RSpec.describe Mihari::Concerns::AutonomousSystemNormalizable do
  subject(:test) { AutonomousSystemTest.new }

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
        expect(test.normalize_asn(value)).to eq(expected)
      end
    end
  end
end
