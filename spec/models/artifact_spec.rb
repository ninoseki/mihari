# frozen_string_literal: true

RSpec.describe Mihari::Models::Artifact do
  let_it_be(:artifact) { FactoryBot.create(:artifact, :ip) }
  let_it_be(:tag) { artifact.tags.first }
  let_it_be(:alert) { artifact.alert }
  let_it_be(:rule) { artifact.rule }

  let(:tag_filter) do
    Mihari::Structs::Filters::Search.new(q: "tag:#{tag.name}")
  end
  let(:empty_rule_filter) do
    Mihari::Structs::Filters::Search.new(q: "rule.id:404_not_found")
  end

  describe "#validate" do
    it do
      obj = described_class.new(data: Faker::Internet.ip_v4_address, alert_id: alert.id)
      expect(obj).to be_valid
      expect(obj.data_type).to eq("ip")
    end
  end

  describe "#unique?" do
    it do
      not_unique = described_class.new(data: artifact.data, alert_id: alert.id).tap do |artifact|
        artifact.rule_id = rule.id
      end
      expect(not_unique).not_to be_unique
    end

    it do
      unique = described_class.new(data: Faker::Internet.unique.ip_v4_address, alert_id: alert.id).tap do |artifact|
        artifact.rule_id = rule.id
      end
      expect(unique).to be_unique
    end

    context "with artifact_lifetime" do
      let(:data) { Faker::Internet.unique.ip_v4_address }
      let!(:artifact_ttl) { 60 }
      let!(:base_time) { Time.now.utc }

      it do
        Timecop.freeze(base_time) do
          described_class.create(data: artifact.data, alert_id: alert.id)
        end

        obj = described_class.new(data: artifact.data, alert_id: alert.id)
        obj.rule_id = rule.id

        expect(obj.unique?(base_time:, artifact_ttl:)).to be false
      end

      it do
        Timecop.freeze(base_time - (artifact_ttl + 1).seconds) do
          described_class.create(data: artifact.data, alert_id: alert.id)
        end

        obj = described_class.new(data: artifact.data, alert_id: alert.id)
        expect(obj.unique?(base_time:, artifact_ttl:)).to be true
      end
    end
  end

  describe "#enrichable?" do
    it do
      expect(artifact.enrichable?).to eq(true)
    end

    context "with unenrichable artifact" do
      let(:artifact) { FactoryBot.build(:artifact, :unenrichable) }

      it do
        expect(artifact.enrichable?).to eq(false)
      end
    end
  end

  describe ".search_by_filter" do
    it do
      artifacts = described_class.search_by_filter(Mihari::Structs::Filters::Search.new(q: ""))
      expect(artifacts.length).to be >= alert.artifacts.length
    end

    it do
      artifacts = described_class.search_by_filter(tag_filter)
      expect(artifacts.length).to be >= alert.artifacts.length
    end

    it do
      artifacts = described_class.search_by_filter(empty_rule_filter)
      expect(artifacts.length).to eq(0)
    end
  end

  describe ".count_by_filter" do
    it do
      count = described_class.count_by_filter(Mihari::Structs::Filters::Search.new(q: ""))
      expect(count).to be >= alert.artifacts.length
    end

    it do
      count = described_class.count_by_filter(tag_filter)
      expect(count).to be >= alert.artifacts.length
    end

    it do
      count = described_class.count_by_filter(empty_rule_filter)
      expect(count).to eq(0)
    end
  end

  describe ".after_destroy" do
    let(:artifact) { FactoryBot.create(:artifact) }
    let(:alert) { artifact.alert }

    it do
      expect(Mihari::Models::Alert.exists?(alert.id)).to eq(true)
    end

    it do
      artifact.destroy
      expect(Mihari::Models::Alert.exists?(alert.id)).to eq(false)
    end
  end
end
