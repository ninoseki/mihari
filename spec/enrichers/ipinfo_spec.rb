# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::IPInfo, vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
  subject { described_class.new }

  describe ".query" do
    let!(:ip) { "1.1.1.1" }

    it do
      res = subject.query(ip)
      expect(res.asn).to eq(13_335)
      expect(res.country_code).to eq("US")
      expect(res.hostname).to eq("one.one.one.one")
    end
  end
end
