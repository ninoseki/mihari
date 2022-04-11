require "json"

RSpec.describe Mihari::Endpoints::Artifacts, :vcr do
  include Rack::Test::Methods
  include_context "with database fixtures"

  def app
    Mihari::Endpoints::Artifacts
  end

  before do
    @artifact = Mihari::Artifact.new(data: "dummy.artifact.example.com")
    @artifact.save
  end

  after do
    @artifact.destroy
  end

  describe "get /api/artifacts/:id" do
    it "returns 400" do
      get "/api/artifacts/foo"
      expect(last_response.status).to eq(400)
    end

    it "returns 404" do
      get "/api/artifacts/99999"
      expect(last_response.status).to eq(404)
    end

    it "returns 200" do
      get "/api/artifacts/#{@artifact.id}"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["id"]).to eq(@artifact.id)

      # the artifact is not enriched so those attrs should be nil
      expect(json["reverseDnsNames"]).to eq(nil)
      expect(json["dnsRecords"]).to eq(nil)
    end

    context "with enriched artifact" do
      before do
        @enriched_domain_artifact = Mihari::Artifact.new(data: "example.com")
        @enriched_domain_artifact.save
        @enriched_domain_artifact.enrich_dns

        @enriched_ip_artifact = Mihari::Artifact.new(data: "1.1.1.1")
        @enriched_ip_artifact.save
        @enriched_ip_artifact.enrich_reverse_dns
      end

      it "has dnsRecords" do
        get "/api/artifacts/#{@enriched_domain_artifact.id}"

        json = JSON.parse(last_response.body.to_s)

        # the artifact is domain so it should have dns_records
        expect(json["reverseDnsNames"]).to eq(nil)
        expect(json["dnsRecords"]).to be_an(Array)
      end

      it "has reverseDnsNames" do
        get "/api/artifacts/#{@enriched_ip_artifact.id}"

        json = JSON.parse(last_response.body.to_s)

        # the artifact is domain so it should have reverse_dns_names
        expect(json["reverseDnsNames"]).to be_an(Array)
        expect(json["dnsRecords"]).to eq(nil)
      end
    end
  end

  describe "get /api/artifacts/:id/enrich" do
    it "returns 201" do
      get "/api/artifacts/#{@artifact.id}/enrich"
      expect(last_response.status).to eq(201)
    end
  end

  describe "delete /api/artifacts/:id" do
    it "returns 400" do
      delete "/api/artifacts/foo"
      expect(last_response.status).to eq(400)
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
