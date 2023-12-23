# frozen_string_literal: true

RSpec.describe Mihari::Web::Endpoints::Artifacts, :vcr do
  include Rack::Test::Methods

  include_context "with database fixtures"

  def app
    Mihari::Web::Endpoints::Artifacts
  end

  let!(:artifact) { Mihari::Models::Artifact.first }

  let_it_be(:alert) { Mihari::Models::Alert.first }

  describe "get /api/artifacts" do
    it "returns 200" do
      get "/api/artifacts"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
    end
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
      get "/api/artifacts/#{artifact.id}"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["id"]).to eq(artifact.id)
    end

    context "with enriched artifact" do
      before do
        allow(Mihari::Models::DnsRecord).to receive(:build_by_domain).and_return(
          [Mihari::Models::DnsRecord.new(resource: "A", value: Faker::Internet.unique.ip_v4_address)]
        )
        allow(Mihari::Models::ReverseDnsName).to receive(:build_by_ip).and_return(
          [Mihari::Models::ReverseDnsName.new(name: Faker::Internet.unique.domain_name)]
        )

        @enriched_domain_artifact = Mihari::Models::Artifact.new(data: Faker::Internet.unique.domain_name,
          alert_id: alert.id)
        @enriched_domain_artifact.enrich_dns
        @enriched_domain_artifact.save

        @enriched_ip_artifact = Mihari::Models::Artifact.new(data: Faker::Internet.unique.ip_v4_address,
          alert_id: alert.id)
        @enriched_ip_artifact.enrich_reverse_dns
        @enriched_ip_artifact.save
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
      get "/api/artifacts/#{artifact.id}/enrich"
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
      delete "/api/artifacts/#{artifact.id}"
      expect(last_response.status).to eq(204)
    end
  end
end
