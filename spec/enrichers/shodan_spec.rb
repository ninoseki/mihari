# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::Shodan, vcr: "Mihari_Enrichers_Shodan/ip:1.1.1.1" do
  subject(:enricher) { described_class.new }

  describe ".call" do
    let!(:artifact) { Mihari::Models::Artifact.new(data: "1.1.1.1") }

    it do
      enricher.call artifact
      expect(artifact.reverse_dns_names.map(&:name)).to eq(["one.one.one.one"])
    end
  end
end
