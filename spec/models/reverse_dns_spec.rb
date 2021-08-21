# frozen_string_literal: true

RSpec.describe Mihari::ReverseDnsName do
  describe ".build_by_ip" do
    let(:ip) { "1.1.1.1" }

    it do
      names = described_class.build_by_ip(ip)
      expect(names).to be_an(Array)
    end
  end
end
