# frozen_string_literal: true

RSpec.describe Mihari::CLI::Validator do
  subject { described_class }

  describe "#rule" do
    let(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }

    it do
      output = capture(:stdout) { subject.start ["rule", path] }
      expect(output).to include("Valid format.")
    end

    context "with invalid rule" do
      let(:path) { File.expand_path("../fixtures/rules/invalid_rule.yml", __dir__) }

      it do
        output = capture(:stdout) do
          expect { subject.start ["rule", path] }.to raise_error(ArgumentError)
        end
        expect(output).to include("Failed to parse")
      end
    end
  end
end
