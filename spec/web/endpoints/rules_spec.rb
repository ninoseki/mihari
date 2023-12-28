# frozen_string_literal: true

RSpec.describe Mihari::Web::Endpoints::Rules do
  include Rack::Test::Methods

  let_it_be(:rule) { FactoryBot.create(:rule) }
  let_it_be(:rule_to_delete) { FactoryBot.create(:rule) }

  def app
    Mihari::Web::Endpoints::Rules
  end

  describe "get /api/rules" do
    it "returns 200" do
      get "/api/rules"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)

      rule_ids = json["results"].map { |rule| rule["id"] }
      expect(rule_ids).to include rule.id
    end
  end

  describe "get /api/rules/:id" do
    it "returns 404" do
      get "/api/rules/#{Faker::Internet.unique.slug}"
      expect(last_response.status).to eq(404)
    end

    it "returns 200" do
      get "/api/rules/#{rule.id}"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["id"]).to eq(rule.id)
    end
  end

  describe "delete /api/rules/:id" do
    it "returns 404" do
      delete "/api/rules/#{Faker::Internet.unique.slug}"
      expect(last_response.status).to eq(404)
    end

    it "returns 204" do
      delete "/api/rules/#{rule_to_delete.id}"
      expect(last_response.status).to eq(204)
    end
  end

  describe "put /api/rules/" do
    let!(:title) { "updated" }
    let!(:data) do
      data = rule.data.deep_dup
      data["title"] = title
      data
    end
    let!(:payload) { { id: rule.id, yaml: data.to_yaml } }

    it "returns 204" do
      put("/api/rules/", payload.to_json, "CONTENT_TYPE" => "application/json")
      expect(last_response.status).to eq(201)

      res = JSON.parse(last_response.body)
      data = YAML.safe_load(res["yaml"])
      expect(data["title"]).to eq(title)
    end
  end

  describe "post /api/rules/" do
    let!(:data) do
      data = rule.data.deep_dup
      data["id"] = SecureRandom.uuid
      data
    end
    let!(:payload) { { yaml: data.to_yaml } }

    it "returns 201" do
      post("/api/rules/", payload.to_json, "CONTENT_TYPE" => "application/json")
      expect(last_response.status).to eq(201)
    end
  end

  describe "post /api/rules/:id/search" do
    it "returns 201" do
      post "/api/rules/#{rule.id}/search"
      expect(last_response.status).to eq(201)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
    end
  end
end
