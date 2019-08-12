# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Base do
  describe "self.inherited" do
    it do
      expect(Mihari.emitters).to be_an(Array)
    end

    it do
      Mihari.emitters.each do |emitter|
        expect(emitter.superclass).to eq(described_class)
      end
    end
  end
end
