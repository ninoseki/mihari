# frozen_string_literal: true

RSpec.describe Mihari::Models::Rule do
  include_context "with database fixtures"

  let_it_be(:rule) { described_class.first }
  let_it_be(:tag) { rule.tags.first.name }

  let(:tag_filter) do
    Mihari::Structs::Filters::Search.new(q: "tag:#{tag}")
  end
  let(:empty_tag_filter) do
    Mihari::Structs::Filters::Search.new(q: "tag:404_not_found")
  end
  let(:title_filter) do
    Mihari::Structs::Filters::Search.new(q: "title:#{rule.title}")
  end
  let(:empty_title_filter) do
    Mihari::Structs::Filters::Search.new(q: "title:404_not_found")
  end
  let(:description_filter) do
    Mihari::Structs::Filters::Search.new(q: "description:#{rule.description}")
  end
  let(:empty_description_filter) do
    Mihari::Structs::Filters::Search.new(q: "description:404_not_found")
  end

  describe ".search_by_filter" do
    it do
      alerts = described_class.search_by_filter(Mihari::Structs::Filters::Search.new(q: ""))
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
        alerts = described_class.search_by_filter(filter)
        expect(alerts.length).to eq(expected)
      end
    end
  end

  describe ".count_by_filter" do
    it do
      count = described_class.count_by_filter(
        Mihari::Structs::Filters::Search.new(q: "")
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
        count = described_class.count_by_filter(filter)
        expect(count).to eq(expected)
      end
    end
  end
end
