# frozen_string_literal: true

class FalsePositiveTest
  include Mihari::Concerns::FalsePositiveValidatable
end

RSpec.describe Mihari::Concerns::FalsePositiveValidatable do
  subject(:test) { FalsePositiveTest.new }

  describe "#normalize_falsepositive" do
    where(:value, :expected) do
      [
        ["foo", "foo"],
        ["/foo", "/foo"],
        ["foo/", "foo/"],
        ["/foo/", /foo/]
      ]
    end

    with_them do
      it do
        expect(test.normalize_falsepositive(value)).to eq(expected)
      end
    end
  end

  describe "#valid_falsepositive?" do
    where(:value, :expected) do
      [
        ["foo", true],
        ["/foo/", true],
        ["/.+/", true],
        ["/*/", false]
      ]
    end

    with_them do
      it do
        expect(test.valid_falsepositive?(value)).to be expected
      end
    end
  end
end
