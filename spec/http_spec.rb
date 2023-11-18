# frozen_string_literal: true

RSpec.describe Mihari::HTTP::Factory, :vcr do
  describe ".post" do
    let!(:payload) { { foo: "bar" } }

    context "with application/x-www-form-urlencoded" do
      let(:headers) { { foo: "bar", "content-type": "application/x-www-form-urlencoded" } }

      it do
        res = described_class.build(headers: headers).post("https://httpbin.org/post", form: payload)
        data = JSON.parse(res.body.to_s)
        expect(data.dig("headers", "Foo")).to eq("bar")
        expect(data.dig("form", "foo")).to eq("bar")
      end
    end

    context "with application/json" do
      let(:headers) { { foo: "bar", "content-type": "application/json" } }

      it do
        res = described_class.build(headers: headers).post("https://httpbin.org/post", json: payload)
        data = JSON.parse(res.body.to_s)
        expect(data.dig("headers", "Foo")).to eq("bar")

        inner_data = JSON.parse(data["data"])
        expect(inner_data["foo"]).to eq("bar")
      end
    end
  end
end
