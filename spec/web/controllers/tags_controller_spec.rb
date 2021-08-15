require "json"

RSpec.describe Mihari::Controllers::TagsController do
  include Rack::Test::Methods
  include_context "with database fixtures"

  def app
    Mihari::Controllers::TagsController
  end

  describe "get /api/tags" do
    it "returns 200" do
      get "/api/tags"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json.is_a?(Array)).to eq(true)
    end
  end
end
