# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::MMDB, :vcr do
  subject(:enricher) { described_class.new }

  describe ".call" do
    let!(:ip) { "1.1.1.1" }

    it do
      res = enricher.call(ip)
      expect(res.asn).to eq(13_335)
      expect(res.country_code).to eq("US")
    end
  end
end
