# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::GooglePublicDNS, :vcr do
  subject { described_class }

  describe ".query" do
    let(:name) { "example.com" }
    let(:type) { "A" }

    it do
      res = subject.query_by_type(name, type)
      expect(res.answers.first.data).to eq("93.184.216.34")
    end
  end
end
