# frozen_string_literal: true

RSpec.describe Mihari::Models::WhoisRecord do
  describe ".build_by_domain" do
    let!(:domain) { "example.com" }

    let!(:enricher) do
      enricher = instance_double("whois_enricher")
      allow(enricher).to receive(:result).and_return(
        Dry::Monads::Result::Success.new(
          described_class.new(domain: "example.com")
        )
      )
      enricher
    end

    it do
      whois_record = described_class.build_by_domain(domain, enricher: enricher)
      expect(whois_record.domain).to eq(domain)
    end
  end
end
