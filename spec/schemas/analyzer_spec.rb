# frozen_string_literal: true

RSpec.describe Mihari::Schemas::AnalyzerRunContract do
  let(:contract) { Mihari::Schemas::AnalyzerRunContract.new }

  context "with valid params" do
    it do
      result = contract.call(description: "foo", title: "foo", source: "foo", artifacts: %w[1.1.1.1], tags: %w[foo])
      expect(result.errors.empty?).to eq(true)
    end
  end

  context "without required params" do
    it do
      result = contract.call(foo: "bar")
      expect(result.errors.empty?).to eq(false)
    end

    it do
      # without description
      result = contract.call(title: "foo", source: "foo", artifacts: %w[1.1.1.1], tags: %w[foo])
      expect(result.errors.empty?).to eq(false)
    end

    it do
      # without title
      result = contract.call(description: "foo", source: "foo", artifacts: %w[1.1.1.1], tags: %w[foo])
      expect(result.errors.empty?).to eq(false)
    end

    it do
      # without source
      result = contract.call(description: "foo", title: "foo", artifacts: %w[1.1.1.1], tags: %w[foo])
      expect(result.errors.empty?).to eq(false)
    end

    it do
      # without artifacts
      result = contract.call(description: "foo", title: "foo", tags: %w[foo])
      expect(result.errors.empty?).to eq(false)
    end
  end
end
