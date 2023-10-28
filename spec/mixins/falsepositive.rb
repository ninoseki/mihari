# frozen_string_literal: true

class Test
  include Mihari::Mixins::FalsePositive
end

RSpec.describe Test do
  subject(:subject) { described_class.new }

  describe "#normalize_falsepositive" do
    it do
      expect(subject.normalize_falsepositive("foo")).to eq("foo")
    end

    it do
      expect(subject.normalize_falsepositive("/foo")).to eq("/foo")
    end

    it do
      expect(subject.normalize_falsepositive("foo/")).to eq("foo/")
    end

    it do
      expect(subject.normalize_falsepositive("/foo/")).to eq(/foo/)
    end
  end

  describe "#falsepositives?" do
    it do
      expect(subject.falsepositives?("foo")).to be true
    end

    it do
      expect(subject.falsepositives?("/foo/")).to be true
    end

    it do
      expect(subject.falsepositives?("/.+/")).to be true
    end

    it do
      expect(subject.falsepositives?("/*/")).to be false
    end
  end
end
