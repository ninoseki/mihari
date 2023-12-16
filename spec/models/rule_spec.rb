# frozen_string_literal: true

RSpec.describe Mihari::Models::Rule do
  include_context "with database fixtures"

  let_it_be(:rule) { described_class.first }

  let(:tag_filter) do
    Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
      tag: rule.tags.first.name
    )
  end
  let(:empty_tag_filter) do
    Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
      tag: "404_not_found"
    )
  end
  let(:title_filter) do
    Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
      title: rule.title
    )
  end
  let(:empty_title_filter) do
    Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
      title: "404_not_found"
    )
  end
  let(:description_filter) do
    Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
      description: rule.description
    )
  end
  let(:empty_description_filter) do
    Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(
      description: "404_not_found"
    )
  end

  describe ".search" do
    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new
      )
      expect(alerts.length).to be >= 2
    end

    where(:filter, :expected) do
      [
        [ref(:tag_filter), 1],
        [ref(:empty_tag_filter), 0],
        [ref(:title_filter), 1],
        [ref(:empty_title_filter), 0],
        [ref(:description_filter), 1],
        [ref(:empty_description_filter), 0]
      ]
    end

    with_them do
      it do
        alerts = described_class.search(filter)
        expect(alerts.length).to eq(expected)
      end
    end
  end

  describe ".count" do
    it do
      count = described_class.count(
        Mihari::Structs::Filters::Rule::SearchFilter.new
      )
      expect(count).to be >= 2
    end

    where(:filter, :expected) do
      [
        [ref(:tag_filter), 1],
        [ref(:empty_tag_filter), 0],
        [ref(:title_filter), 1],
        [ref(:empty_title_filter), 0],
        [ref(:description_filter), 1],
        [ref(:empty_description_filter), 0]
      ]
    end

    with_them do
      it do
        count = described_class.count(filter)
        expect(count).to eq(expected)
      end
    end
  end
end
