# frozen_string_literal: true

class Test
  include Mihari::Mixins::FalsePositiveValidatable
end

RSpec.describe Test do
  subject(:subject) { described_class.new }

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
        expect(subject.normalize_falsepositive(value)).to eq(expected)
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
        expect(subject.valid_falsepositive?(value)).to be expected
      end
    end
  end
end
