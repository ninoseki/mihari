# frozen_string_literal: true

RSpec.describe Mihari::Web::Endpoints::Alerts do
  include Rack::Test::Methods

  include_context "with database fixtures"

  let_it_be(:alert) { Mihari::Models::Alert.first }
  let_it_be(:rule) { Mihari::Models::Rule.first }

  def app
    Mihari::Web::Endpoints::Alerts
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
    it "returns 200" do
      get "/api/alerts"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
    end

    context "with invalid page type" do
      it "returns 400" do
        get "/api/alerts", { page: "foo" }
        expect(last_response.status).to eq(400)
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
      let!(:payload) { { ruleId: rule.id, artifacts: ["1.1.1.1"] } }

      it "returns 201" do
        post("/api/alerts/", payload.to_json, "CONTENT_TYPE" => "application/json")
        expect(last_response.status).to eq(201)
      end
    end
  end
end
