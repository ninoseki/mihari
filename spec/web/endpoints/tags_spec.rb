# frozen_string_literal: true

RSpec.describe Mihari::Web::Endpoints::Tags do
  include Rack::Test::Methods

  let_it_be(:tag) { FactoryBot.create(:tag) }

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

  describe "delete /api/tags/:id" do
    it "returns 201" do
      delete "/api/tags/#{tag.id}"
      expect(last_response.status).to eq(204)
    end
  end
end
