# frozen_string_literal: true

class Test
  include Mihari::Mixins::DisallowedDataValue
end

RSpec.describe Test do
  subject { described_class.new }

  describe "#normalize_disallowed_data_value" do
    it do
      expect(subject.normalize_disallowed_data_value("foo")).to eq("foo")
    end

    it do
      expect(subject.normalize_disallowed_data_value("/foo")).to eq("/foo")
    end

    it do
      expect(subject.normalize_disallowed_data_value("foo/")).to eq("foo/")
    end

    it do
      expect(subject.normalize_disallowed_data_value("/foo/")).to eq(/foo/)
    end
  end

  describe "#valid_disallowed_data_value?" do
    it do
      expect(subject.valid_disallowed_data_value?("foo")).to be true
    end

    it do
      expect(subject.valid_disallowed_data_value?("/foo/")).to be true
    end

    it do
      expect(subject.valid_disallowed_data_value?("/.+/")).to be true
    end

    it do
      expect(subject.valid_disallowed_data_value?("/*/")).to be false
    end
  end
end
