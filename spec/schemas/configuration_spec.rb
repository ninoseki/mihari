# frozen_string_literal: true

RSpec.describe Mihari::Schemas::Configuration do
  let(:contract) { Mihari::Schemas::ConfigurationContract.new }

  context "with valid rule" do
    it do
      result = contract.call(virustotal_api_key: "foo")
      expect(result.errors.empty?).to eq(true)
    end

    it do
      result = contract.call(webhook_use_json_body: true)
      expect(result.errors.empty?).to eq(true)
    end

    it do
      result = contract.call(webhook_use_json_body: "true")
      expect(result.errors.empty?).to eq(true)
    end
  end

  context "with invalid type" do
    it do
      result = contract.call(virustotal_api_key: nil) # it should be string
      expect(result.errors.empty?).to eq(false)
    end

    it do
      result = contract.call(webhook_use_json_body: "bar") # it should be bool
      expect(result.errors.empty?).to eq(false)
    end
  end
end
