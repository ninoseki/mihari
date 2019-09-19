# frozen_string_literal: true

RSpec.describe Mihari::Cache do
  subject { described_class.new }

  let(:key) { "foo" }

  before { FakeFS.activate! }

  after { FakeFS.deactivate! }

  describe "#cached?" do
    before { subject.save key }

    it do
      expect(subject.cached?(key)).to eq(true)
    end

    context "when 8 days passed" do
      it do
        Timecop.freeze(Date.today + 8) do
          expect(subject.cached?(key)).to eq(false)
        end
      end
    end
  end
end
