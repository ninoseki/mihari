ENV["APP_ENV"] = "test"

require "rack/test"

RSpec.describe Mihari::App do
  include Rack::Test::Methods

  def app
    Mihari::App
  end

  it "returns 200" do
    paths = %w[/ /api/alerts /api/tags /api/sources /api/config]
    paths.each do |path|
      get path
      expect(last_response).to be_ok
    end
  end
end
