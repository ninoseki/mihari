# frozen_string_literal: true

RSpec.describe Mihari::TypeChecker do
  subject { described_class }

  describe ".type" do
    context "when given an ip address" do
      it do
        expect(subject.type("1.1.1.1")).to eq("ip")
      end
    end

    context "when given a domain" do
      it do
        expect(subject.type("example.com")).to eq("domain")
      end
    end

    context "when given a url" do
      it do
        expect(subject.type("http://example.com")).to eq("url")
      end
    end

    context "when given a hash" do
      it do
        expect(subject.type("275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f")).to eq("hash")
      end
    end

    context "when given an email" do
      it do
        expect(subject.type("example@gmail.com")).to eq("mail")
      end
    end
  end
end
