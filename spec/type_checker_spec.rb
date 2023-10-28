# frozen_string_literal: true

RSpec.describe Mihari::TypeChecker do
  subject(:type_checker) { described_class }

  describe ".type" do
    context "when ip" do
      let!(:ip) { "1.1.1.1" }

      it do
        expect(type_checker.type(ip)).to eq("ip")
      end
    end

    context "with domain" do
      let!(:domain) { "example.com" }

      it do
        expect(type_checker.type(domain)).to eq("domain")
      end
    end

    context "when given a url" do
      let!(:url) { "http://example.com" }

      it do
        expect(type_checker.type(url)).to eq("url")
      end
    end

    context "with hash" do
      let!(:hash) { "275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f" }

      it do
        expect(type_checker.type(hash)).to eq("hash")
      end
    end

    context "with mail" do
      let!(:mail) { "example@example.com" }

      it do
        expect(type_checker.type(mail)).to eq("mail")
      end
    end
  end

  describe ".detailed_type" do
    context "with sha256" do
      let!(:sha256) { "275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f" }

      it do
        expect(type_checker.detailed_type(sha256)).to eq("sha256")
      end
    end

    context "with md5" do
      let!(:md5) { "44d88612fea8a8f36de82e1278abb02f" }

      it do
        expect(type_checker.detailed_type(md5)).to eq("md5")
      end
    end
  end
end
