require "json"

RSpec.describe Mihari::Controllers::IPAddressController, :vcr do
  include Rack::Test::Methods

  def app
    Mihari::Controllers::IPAddressController
  end

  let(:ip) { "1.1.1.1" }

  describe "get /api/ip_addresses/:ip" do
    it "returns 200" do
      get "/api/ip_addresses/#{ip}"
      expect(last_response.status).to eq(200)

      json = JSON.parse(last_response.body.to_s)
      expect(json.is_a?(Hash)).to eq(true)
      expect(json["ip"]).to eq(ip)
    end
  end
end
