# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::GooglePublicDNS, :vcr do
  describe ".query_by_type" do
    subject(:enricher) { described_class.new }

    let!(:name) { "example.com" }

    it do
      res = enricher.call(name)
      expect(res.answers.first.data).to eq("93.184.216.34")
    end
  end
end
