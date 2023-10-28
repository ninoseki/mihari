# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::Shodan, vcr: "Mihari_Enrichers_Shodan/ip:1.1.1.1" do
  subject(:enricher) { described_class.new }

  describe ".query" do
    let!(:ip) { "1.1.1.1" }

    it do
      res = enricher.query(ip)
      expect(res.hostnames).to eq(["one.one.one.one"])
    end
  end
end
