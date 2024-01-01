# frozen_string_literal: true

RSpec.describe Mihari::Services::CPEBuilder, vcr: "Mihari_Enrichers_Shodan/ip:1.1.1.1" do
  describe ".call" do
    let!(:ip) { "1.1.1.1" }

    it do
      names = described_class.call(ip)
      expect(names).to be_an(Array)
    end
  end
end
