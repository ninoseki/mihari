# frozen_string_literal: true

RSpec.describe Mihari::Web::Endpoints::Tags do
  include Rack::Test::Methods

  include_context "with database fixtures"

  def app
    Mihari::Web::Endpoints::Tags
  end

  describe "get /api/tags" do
    it "returns 200" do
      get "/api/tags"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["results"]).to be_an(Array)
    end
  end
end
