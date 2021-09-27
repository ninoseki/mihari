require "json"

RSpec.describe Mihari::Endpoints::IPAddresses, :vcr do
  include Rack::Test::Methods

  def app
    Mihari::Endpoints::IPAddresses
  end

  let(:ip) { "1.1.1.1" }

  describe "get /api/ip_addresses/:ip" do
    it "returns 200" do
      get "/api/ip_addresses/#{ip}"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
      expect(json["ip"]).to eq(ip)
    end
  end
end
