require "json"

RSpec.describe Mihari::Controllers::SourcesController do
  include Rack::Test::Methods
  include_context "with database fixtures"

  def app
    Mihari::Controllers::SourcesController
  end

  describe "get /api/sources" do
    it "returns 200" do
      get "/api/sources"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json.is_a?(Array)).to eq(true)
    end
  end
end
