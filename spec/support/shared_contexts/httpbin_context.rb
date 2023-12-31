# frozen_string_literal: true

require "capybara"

require_relative "../httpbin"

RSpec.shared_context "with fake HTTPBin" do
  before(:all) do
    @server = Capybara::Server.new(HTTPBin)
    @server.boot
  end
end
