# frozen_string_literal: true

RSpec.describe Mihari::CLI::Main do
  subject { described_class }

  describe "#validate" do
    let(:rule) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }

    it do
      output = capture(:stdout) { subject.start ["validate", rule] }
      expect(output).to include("Valid format.")
    end

    context "with invalid rule" do
      let(:rule) { File.expand_path("../fixtures/rules/invalid_rule.yml", __dir__) }
      it do
        output = capture(:stdout) do
          expect { subject.start ["validate", rule] }.to raise_error(ArgumentError)
        end
        expect(output).to include("Failed to parse")
      end
    end
  end
end
