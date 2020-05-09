# frozen_string_literal: true

RSpec.describe Mihari::AlertViewer do
  include_context "with database"

  subject { described_class.new }

  describe "#list" do
    before do
      artifacts = [Mihari::Artifact.create(data: "1.1.1.1", data_type: "ip")]
      tags = [Mihari::Tag.create(name: "foo")]
      taggings = tags.map { |tag| Mihari::Tagging.new(tag_id: tag.id) }

      alert = Mihari::Alert.new(
        title: "test",
        description: "test",
        artifacts: artifacts,
        source: "test",
        taggings: taggings
      )
      alert.save
    end

    it do
      alerts = subject.list
      alerts.each do |alert|
        expect(alert.keys.sort).to eq([:artifacts, :created_at, :description, :source, :tags, :title])
      end
    end

    context "when given --limit option" do
      it do
        expect { subject.list(lmit: -1) }.to raise_error(ArgumentError)
      end

      it do
        expect { subject.list(limit: "foo bar") }.to raise_error(ArgumentError)
      end
    end

    context "when given --tag option" do
      it do
        alerts = subject.list(tag: "foo")
        expect(alerts.length).to eq(1)
      end

      it do
        alerts = subject.list(tag: "bar")
        expect(alerts.length).to eq(0)
      end
    end

    context "when given --title option" do
      it do
        alerts = subject.list(title: "test")
        expect(alerts.length).to eq(1)
      end

      it do
        alerts = subject.list(title: "foo")
        expect(alerts.length).to eq(0)
      end
    end

    context "when given --source option" do
      it do
        alerts = subject.list(source: "test")
        expect(alerts.length).to eq(1)
      end

      it do
        alerts = subject.list(source: "foo")
        expect(alerts.length).to eq(0)
      end
    end
  end
end
