# frozen_string_literal: true

RSpec.describe Mihari::Endpoints::Alerts do
  include Rack::Test::Methods

  include_context "with database fixtures"

  let!(:alert) { Mihari::Models::Alert.first }
  let!(:rule) { Mihari::Models::Rule.first }

  def app
    Mihari::Endpoints::Alerts
  end

  describe "delete /api/alerts/:id" do
    it "returns 400" do
      delete "/api/alerts/foo"
      expect(last_response.status).to eq(400)
    end

    it "returns 404" do
      delete "/api/alerts/99999"
      expect(last_response.status).to eq(404)
    end

    it "returns 204" do
      alert_id = alert.id
      delete "/api/alerts/#{alert_id}"
      expect(last_response.status).to eq(204)
    end
  end

  describe "get /api/alerts" do
    context "with invalid DateTime" do
      it "returns 400" do
        get "/api/alerts", { fromAt: "foo" }
        expect(last_response.status).to eq(400)
      end

      it "returns 400" do
        get "/api/alerts", { fromAt: "2021-05" }
        expect(last_response.status).to eq(400)
      end
    end

    context "with valid DateTime" do
      it "returns 200" do
        get "/api/alerts", { fromAt: Time.now }
        expect(last_response.status).to eq(200)

        json = JSON.parse(last_response.body.to_s)
        expect(json).to be_a(Hash)
      end
    end
  end

  describe "post /api/alerts" do
    context "with invalid params" do
      it "returns 400" do
        post "/api/alerts", { foo: "bar" }
        expect(last_response.status).to eq(400)
      end
    end

    context "with valid params" do
      it "returns 201" do
        payload = {
          ruleId: rule.id,
          artifacts: ["1.1.1.1"]
        }
        post("/api/alerts/", payload.to_json, "CONTENT_TYPE" => "application/json")
        expect(last_response.status).to eq(201)
      end
    end
  end
end
