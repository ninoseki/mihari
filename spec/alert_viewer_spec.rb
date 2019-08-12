# frozen_string_literal: true

RSpec.describe Mihari::AlertViewer, :vcr do
  subject { described_class.new }

  describe "#initialize" do
    it do
      expect { described_class.new(limit: -1) }.to raise_error(ArgumentError)
    end

    it do
      expect { described_class.new(limit: "foo bar") }.to raise_error(ArgumentError)
    end
  end

  describe "#list" do
    it do
      alerts = subject.list
      alerts.each do |alert|
        expect(alert.keys.sort).to eq(%w(title description artifacts tags createdAt status).sort)
      end
    end
  end
end
