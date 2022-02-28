# frozen_string_literal: true

RSpec.describe Mihari::HTTP, :vcr do
  describe ".post" do
    let(:headers) { { foo: "bar" } }
    let(:payload) { { foo: "bar" } }

    context "with application/x-www-form-urlencoded" do
      it do
        res = described_class.post("https://httpbin.org/post", headers: headers, payload: payload, payload_type: "application/x-www-form-urlencoded")

        data = JSON.parse(res.body.to_s)

        expect(data.dig("headers", "Foo")).to eq("bar")
        expect(data.dig("form", "foo")).to eq("bar")
      end
    end

    context "with application/json" do
      it do
        res = described_class.post("https://httpbin.org/post", headers: headers, payload: payload, payload_type: "application/json")

        data = JSON.parse(res.body.to_s)

        expect(data.dig("headers", "Foo")).to eq("bar")

        inner_data = JSON.parse(data["data"])
        expect(inner_data["foo"]).to eq("bar")
      end
    end
  end
end
