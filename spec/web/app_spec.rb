# frozen_string_literal: true

RSpec.describe Mihari::Web::App do
  include Rack::Test::Methods

  def app
    described_class.instance
  end

  it "returns 200" do
    paths = %w[/ /api/alerts /api/tags /api/configs]
    paths.each do |path|
      get path
      expect(last_response).to be_ok
    end
  end
end
