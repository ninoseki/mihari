# frozen_string_literal: true

RSpec.describe Mihari::TheHive, :vcr do
  subject { Mihari::TheHive.new }

  describe "#exists?" do
    context "when give a not existing value" do
      it do
        expect(subject.exists?(data: "null.example.com", data_type: "domain")).to be(false)
      end
    end

    context "when give an existing value" do
      it do
        expect(subject.exists?(data: "1.1.1.1", data_type: "ip")).to be(true)
      end
    end
  end
end
