# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::GooglePublicDNS, :vcr do
  subject(:enricher) { described_class.new }

  describe ".query" do
    let!(:name) { "example.com" }
    let!(:type) { "A" }

    it do
      res = enricher.query_by_type(name, type)
      expect(res.answers.first.data).to eq("93.184.216.34")
    end
  end
end
