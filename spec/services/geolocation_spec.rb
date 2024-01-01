# frozen_string_literal: true

RSpec.describe Mihari::Services::GeolocationBuilder, vcr: "Mihari_Enrichers_MMDB/ip:1.1.1.1" do
  describe ".call" do
    let!(:ip) { "1.1.1.1" }

    it do
      geolocation = described_class.call(ip)
      expect(geolocation.country_code).to eq("US")
      expect(geolocation.country).to eq("United States")
    end
  end
end
