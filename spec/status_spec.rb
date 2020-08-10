# frozen_string_literal: true

RSpec.describe Mihari::Status do
  subject { described_class.new }

  describe "#check?" do
    it do
      result = subject.check
      expect(result.all? { |_k, v| v.key?(:status) && v.key?(:message) }).to eq(true)
    end
  end
end
