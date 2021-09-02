# frozen_string_literal: true

RSpec.describe Mihari::Geolocation, vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
  subject { described_class }

  describe ".build_by_ip" do
    let(:ip) { "1.1.1.1" }

    it do
      geolocation = subject.build_by_ip(ip)
      expect(geolocation.country_code).to eq("US")
      expect(geolocation.country).to eq("United States")
    end
  end
end
