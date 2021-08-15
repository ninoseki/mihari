require "json"

RSpec.describe Mihari::Controllers::ArtifactsController do
  include Rack::Test::Methods
  include_context "with database fixtures"

  def app
    Mihari::Controllers::ArtifactsController
  end

  before do
    @artifact = Mihari::Artifact.new(data: "dummy.artifact.example.com")
    @artifact.save
  end

  after do
    @artifact.destroy
  end

  describe "get /api/artifacts/:id" do
    it "returns 500" do
      get "/api/artifacts/foo"
      expect(last_response.status).to eq(500)
    end

    it "returns 404" do
      get "/api/artifacts/99999"
      expect(last_response.status).to eq(404)
    end

    it "returns 200" do
      get "/api/artifacts/#{@artifact.id}"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json.is_a?(Hash)).to eq(true)
      expect(json["id"]).to eq(@artifact.id)
    end
  end

  describe "delete /api/artifacts/:id" do
    it "returns 500" do
      delete "/api/artifacts/foo"
      expect(last_response.status).to eq(500)
    end

    it "returns 404" do
      delete "/api/artifacts/99999"
      expect(last_response.status).to eq(404)
    end

    it "returns 201" do
      delete "/api/artifacts/#{@artifact.id}"
      expect(last_response.status).to eq(204)
    end
  end
end
