# frozen_string_literal: true

require "json"

RSpec.describe Mihari::Web::Endpoints::IPAddresses, :vcr do
  include Rack::Test::Methods

  def app
    Mihari::Web::Endpoints::IPAddresses
  end

  let!(:ip) { "1.1.1.1" }

  describe "get /api/ip_addresses/:ip" do
    it "returns 200" do
      get "/api/ip_addresses/#{ip}"
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body.to_s)
      expect(json).to be_a(Hash)
    end

    context "when get 404 from upwards" do
      before do
        allow(Mihari::Services::IPGetter).to receive(:result).and_return(
          Dry::Monads::Result::Failure.new(
            Mihari::StatusError.new("dummy", 404, "")
          )
        )
      end

      it "returns 422" do
        get "/api/ip_addresses/404"
        expect(last_response.status).to eq(422)
      end
    end
  end
end
