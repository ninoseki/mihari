# frozen_string_literal: true

RSpec.describe Mihari::Artifact do
  describe "#type" do
    context "when given a hash" do
      let(:values) {
        %w(
          68b329da9893e34099c7d8ad5cb9c940
          adc83b19e793491b1c6ea0fd8b46cd9f32e592fc
          01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b be688838ca8686e5c90689bf2ab585cef1137c999b48c70b92f67a5c34dc15697b5d11c982ed6d71be1e1e7f7b4e0733884aa97c3f7a339a8ed03577cf74be09
        )
      }

      it do
        values.each do |value|
          expect(described_class.new(value).data_type).to eq("hash")
        end
      end
    end

    context "when given an IP" do
      let(:values) {
        %w(
          1.1.1.1
          8.8.8.8
          127.0.0.1
          fdc4:2581:575b:5a72:0000:0000:0000:0001
        )
      }

      it do
        values.each do |value|
          expect(described_class.new(value).data_type).to eq("ip")
        end
      end
    end

    context "when given a domain" do
      let(:values) {
        %w(
          github.com
          example.com
          google.co.jp
        )
      }

      it do
        values.each do |value|
          expect(described_class.new(value).data_type).to eq("domain")
        end
      end
    end

    context "when given a URL" do
      let(:values) {
        %w(
          http://example.com/
          https://example.com/
          http://example.com
          http://192.168.0.1
          http://example.com:80/path
        )
      }

      it do
        values.each do |value|
          expect(described_class.new(value).data_type).to eq("url")
        end
      end
    end

    context "when given an email" do
      let(:values) {
        %w(
          allen@google.com
          ninoseki@gmail.com
        )
      }

      it do
        values.each do |value|
          expect(described_class.new(value).data_type).to eq("mail")
        end
      end
    end
  end

  describe "#valid?" do
    context "when given an invalid input" do
      let(:values) {
        %w(
          test
          1
          adc83b191b1c6ea0fd8b46cd9f32e592fc
        )
      }

      it do
        values.each do |value|
          expect(described_class.new(value).valid?).to be false
        end
      end
    end
  end
end
