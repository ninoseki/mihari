# frozen_string_literal: true

RSpec.describe Mihari::Web::App do
  include Rack::Test::Methods

  def app
    described_class.instance
  end

  where(:path) { %w[/ /api/alerts /api/tags /api/configs] }

  with_them do
    it "returns 200" do
      get path
      expect(last_response).to be_ok
    end
  end
end
