# frozen_string_literal: true

class Testable < Grape::API
  prefix "api"
  format :json

  mount Mihari::Web::Endpoints::Tags
end

RSpec.describe Mihari::Web::Endpoints::Tags do
  include Rack::Test::Methods

  let_it_be(:tag) { FactoryBot.create(:tag) }

  def app
    Testable
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
    it "returns 204" do
      delete "/api/tags/#{tag.id}"
      expect(last_response.status).to eq(204)
    end

    it "returns 404" do
      delete "/api/tags/0"
      expect(last_response.status).to eq(404)
    end
  end
end
