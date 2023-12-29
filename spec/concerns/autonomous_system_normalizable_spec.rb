# frozen_string_literal: true

class AutonomousSystemTest
  include Mihari::Concerns::AutonomousSystemNormalizable
end

RSpec.describe Mihari::Concerns::AutonomousSystemNormalizable do
  subject(:subject) { AutonomousSystemTest.new }

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
