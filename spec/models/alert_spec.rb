# frozen_string_literal: true

RSpec.describe Mihari::Models::Alert do
  let_it_be(:alert) { FactoryBot.create(:alert_with_artifacts) }
  let_it_be(:artifact) { alert.artifacts.first }
  let_it_be(:tag) { alert.tags.first }

  let(:tag_filter) do
    Mihari::Structs::Filters::Search.new(q: "tag:#{tag.name}")
  end
  let(:artifact_filter) do
    Mihari::Structs::Filters::Search.new(q: "artifact.data:#{artifact.data}")
  end
  let(:empty_rule_filter) do
    Mihari::Structs::Filters::Search.new(q: "rule.id:404_not_found")
  end

  describe ".search_by_filter" do
    it do
      alerts = described_class.search_by_filter(Mihari::Structs::Filters::Search.new(q: ""))
      expect(alerts.length).to be >= 1
    end

    where(:filter, :expected) do
      [
        [ref(:tag_filter), 1],
        [ref(:artifact_filter), 1],
        [ref(:empty_rule_filter), 0]
      ]
    end

    with_them do
      it do
        alerts = described_class.search_by_filter(filter)
        expect(alerts.length).to eq(expected)
      end
    end
  end

  describe ".count" do
    it do
      count = described_class.count_by_filter(
        Mihari::Structs::Filters::Search.new(q: "")
      )
      expect(count).to be >= 1
    end

    where(:filter, :expected) do
      [
        [ref(:tag_filter), 1],
        [ref(:artifact_filter), 1],
        [ref(:empty_rule_filter), 0]
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
