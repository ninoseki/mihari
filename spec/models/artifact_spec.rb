# frozen_string_literal: true

require "timecop"

RSpec.describe Mihari::Artifact do
  describe "#validate" do
    it do
      artifact = described_class.new(data: "1.1.1.1")
      expect(artifact).to be_valid
      expect(artifact.data_type).to eq("ip")
    end
  end

  describe "#unique?" do
    before do
      described_class.all.each(&:delete)
      described_class.create(data: "1.1.1.1")
    end

    it do
      artifact = described_class.new(data: "1.1.1.1")
      expect(artifact).not_to be_unique
    end

    it do
      artifact = described_class.new(data: "2.2.2.2")
      expect(artifact).to be_unique
    end

    context "with --ignore-old-artifacts" do
      let(:days) { 2 }
      let(:data) { "1.1.1.1" }

      before do
        described_class.all.each(&:delete)

        Timecop.freeze((-days).days.from_now) do
          described_class.create(data: data)
        end
      end

      it do
        artifact = described_class.new(data: data)

        (0..days).each do |day|
          expect(artifact.unique?(ignore_old_artifacts: true, ignore_threshold: day)).to eq(true)
        end

        expect(artifact.unique?(ignore_old_artifacts: true, ignore_threshold: days + 1)).to eq(false)
        expect(artifact.unique?(ignore_old_artifacts: true, ignore_threshold: days + 2)).to eq(false)
      end
    end
  end
end
