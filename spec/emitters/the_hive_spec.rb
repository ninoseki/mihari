# frozen_string_literal: true

RSpec.describe Mihari::Emitters::TheHive, :vcr do
  subject { described_class.new }

  describe "#valid?" do
    context "when SLAC_WEBHOOK_URL is given" do
      before do
        allow(ENV).to receive(:key?).with("THEHIVE_API_ENDPOINT").and_return(true)
        allow(ENV).to receive(:key?).with("THEHIVE_API_KEY").and_return(true)
      end

      it do
        expect(subject.valid?).to be(true)
      end
    end

    context "when THEHIVE_API_ENDPOINT is not given" do
      before do
        allow(ENV).to receive(:key?).with("THEHIVE_API_ENDPOINT").and_return(false)
      end

      it do
        expect(subject.valid?).to be(false)
      end
    end
  end
end
