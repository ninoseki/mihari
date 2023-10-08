# frozen_string_literal: true

RSpec.describe Mihari::AutonomousSystem, vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
  subject { described_class }

  describe ".build_by_ip" do
    let!(:ip) { "1.1.1.1" }

    it do
      as = subject.build_by_ip(ip)
      expect(as.asn).to eq(13_335)
    end
  end
end
