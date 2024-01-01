# frozen_string_literal: true

RSpec.describe Mihari::Services::AutonomousSystemBuilder, vcr: "Mihari_Enrichers_MMDB/ip:1.1.1.1" do
  describe ".call" do
    let!(:ip) { "1.1.1.1" }

    it do
      as = described_class.call(ip)
      expect(as.asn).to eq(13_335)
    end
  end
end
