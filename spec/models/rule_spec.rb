# frozen_string_literal: true

RSpec.describe Mihari::Rule do
  include_context "with database fixtures"

  describe ".search" do
    it do
      alerts = described_class.search(Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new)
      expect(alerts.length).to eq(2)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(tag_name: "tag1"))
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(tag_name: "404_not_found"))
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(title: "404_not_found"))
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(title: "test1"))
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(description: "404_not_found"))
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(description: "test"))
      expect(alerts.length).to eq(2)
    end
  end

  describe ".count" do
    it do
      count = described_class.count(Mihari::Structs::Filters::Rule::SearchFilter.new)
      expect(count).to eq(2)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Rule::SearchFilter.new(tag_name: "tag1"))
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Rule::SearchFilter.new(tag_name: "404_not_found"))
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Rule::SearchFilter.new(title: "404_not_found"))
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Rule::SearchFilter.new(title: "test1"))
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Rule::SearchFilter.new(description: "404_not_found"))
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Rule::SearchFilter.new(description: "test"))
      expect(count).to eq(2)
    end
  end
end
