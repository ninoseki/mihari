# frozen_string_literal: true

RSpec.describe Mihari::HTTP::Factory do
  include_context "with fake HTTPBin"

  describe ".get" do
    context "with 200" do
      it do
        res = described_class.build.get("#{server.base_url}/get")
        json = JSON.parse(res.body.to_s)
        expect(json["headers"]["User-Agent"]).to start_with("mihari/")
      end
    end

    context "with 404" do
      it do
        expect do
          described_class.build.get("#{server.base_url}/status/404")
        end.to raise_error(Mihari::StatusCodeError)
      end
    end

    context "with timeout" do
      it do
        expect do
          described_class.build(timeout: -1).get("#{server.base_url}/get")
        end.to raise_error(::HTTP::TimeoutError)
      end
    end
  end

  describe ".post" do
    context "with application/x-www-form-urlencoded" do
      let!(:form) { { foo: "bar" } }
      let(:headers) { { "content-type": "application/x-www-form-urlencoded" } }

      it do
        res = described_class.build(headers: headers).post("#{server.base_url}/post", form: form)
        data = JSON.parse(res.body.to_s)
        expect(data.dig("form", "foo")).to eq("bar")
      end
    end

    context "with application/json" do
      let!(:json) { { foo: "bar" } }
      let(:headers) { { "content-type": "application/json" } }

      it do
        res = described_class.build(headers: headers).post("#{server.base_url}/post", json: json)
        data = JSON.parse(res.body.to_s)
        inner_data = JSON.parse(data["data"])
        expect(inner_data["foo"]).to eq("bar")
      end
    end
  end
end
