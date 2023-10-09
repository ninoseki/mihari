# frozen_string_literal: true

RSpec.describe Mihari::Rule do
  include_context "with database fixtures"

  let!(:rule) { Mihari::Rule.first }

  describe ".search" do
    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new
      )
      expect(alerts.length).to be >= 2
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
          tag_name: rule.tags.first.name
        )
      )
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
          tag_name: "404_not_found"
        )
      )
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
          title: "404_not_found"
        )
      )
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
          title: rule.title
        )
      )
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
          description: "404_not_found"
        )
      )
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
          description: rule.description
        )
      )
      expect(alerts.length).to eq(1)
    end
  end

  describe ".count" do
    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new
      )
      expect(count).to be >= 2
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new(
          tag_name: rule.tags.first.name
        )
      )
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new(
          tag_name: "404_not_found"
        )
      )
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new(
          title: "404_not_found"
        )
      )
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new(
          title: rule.title
        )
      )
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new(
          description: "404_not_found"
        )
      )
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new(
          description: rule.description
        )
      )
      expect(count).to eq(1)
    end
  end
end
