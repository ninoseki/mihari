require "json"
require "time"

RSpec.describe Mihari::Controllers::AlertsController do
  include Rack::Test::Methods
  include_context "with database fixtures"

  def app
    Mihari::Controllers::AlertsController
  end

  describe "delete /api/alerts/:id" do
    it "returns 500" do
      delete "/api/alerts/foo"
      expect(last_response.status).to eq(500)
    end

    it "returns 404" do
      delete "/api/alerts/99999"
      expect(last_response.status).to eq(404)
    end

    it "returns 200" do
      alert_id = @alerts.first.id
      delete "/api/alerts/#{alert_id}"
      expect(last_response.status).to eq(204)
    end
  end

  describe "get /api/alerts" do
    context "with invalid DateTime" do
      it "returns 500" do
        get "/api/alerts", { fromAt: "foo" }
        expect(last_response.status).to eq(500)
      end

      it "returns 500" do
        get "/api/alerts", { fromAt: "2021-05" }
        expect(last_response.status).to eq(500)
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
end
