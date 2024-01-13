# frozen_string_literal: true

RSpec.describe Mihari::Services::WhoisRecordBuilder do
  describe ".call" do
    let!(:domain) { "example.com" }

    let!(:enricher) do
      enricher = instance_double("whois_enricher")
      allow(enricher).to receive(:result).and_return(
        Dry::Monads::Result::Success.new(
          Mihari::Models::WhoisRecord.new(domain: "example.com")
        )
      )
      enricher
    end

    it do
      whois_record = described_class.call(domain, enricher: enricher)
      expect(whois_record.domain).to eq(domain)
    end
  end
end
