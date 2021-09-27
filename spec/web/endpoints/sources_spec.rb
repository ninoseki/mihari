require "json"

RSpec.describe Mihari::Endpoints::Sources do
  include Rack::Test::Methods
  include_context "with database fixtures"

  def app
    Mihari::Endpoints::Sources
  end

  describe "get /api/sources" do
    it "returns 200" do
      get "/api/sources"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["sources"]).to be_an(Array)
    end
  end
end
