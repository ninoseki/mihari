require "json"
require "securerandom"

RSpec.describe Mihari::Endpoints::Rules do
  include Rack::Test::Methods
  include_context "with database fixtures"

  def app
    Mihari::Endpoints::Rules
  end

  let(:id) { "dummy" }
  let(:title) { "dummy" }
  let(:description) { "dummy" }
  let(:queries) { [{ analyzer: "crtsh", query: "foo" }] }

  let(:data) do
    { title: title, description: description, queries: queries }
  end
  let(:yaml) { data.to_yaml }

  before do
    @rule = Mihari::Rule.new(id: id, title: title, description: description, data: data, yaml: yaml)
    @rule.save
  end

  after do
    @rule.destroy
  end

  describe "get /api/rules" do
    it "returns 200" do
      get "/api/rules"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["rules"].first["id"]).to eq(@rule.id)
    end
  end

  describe "get /api/rules/:id" do
    it "returns 404" do
      get "/api/rules/99999"
      expect(last_response.status).to eq(404)
    end

    it "returns 200" do
      get "/api/rules/#{@rule.id}"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["id"]).to eq(@rule.id)
    end
  end

  describe "delete /api/rules/:id" do
    it "returns 404" do
      delete "/api/rules/99999"
      expect(last_response.status).to eq(404)
    end

    it "returns 204" do
      delete "/api/rules/#{@rule.id}"
      expect(last_response.status).to eq(204)
    end
  end

  describe "put /api/rules/" do
    let(:title) { "updated" }

    it "returns 204" do
      data = @rule.data.deep_dup
      data["title"] = title

      payload = {
        id: @rule.id,
        yaml: data.to_yaml
      }
      put("/api/rules/", payload.to_json, "CONTENT_TYPE" => "application/json")

      expect(last_response.status).to eq(201)

      res = JSON.parse(last_response.body)
      data = YAML.safe_load(res["yaml"])
      expect(data["title"]).to eq(title)
    end
  end

  describe "post /api/rules/" do
    it "returns 201" do
      data = @rule.data.deep_dup
      data["id"] = SecureRandom.uuid
      payload = { yaml: data.to_yaml }

      post("/api/rules/", payload.to_json, "CONTENT_TYPE" => "application/json")

      expect(last_response.status).to eq(201)
    end
  end
end
