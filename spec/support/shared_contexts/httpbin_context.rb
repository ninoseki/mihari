# frozen_string_literal: true

require "capybara"

require_relative "../httpbin"

RSpec.shared_context "with fake HTTPBin" do
  let_it_be(:server) do
    server = Capybara::Server.new(HTTPBin)
    server.boot
    server
  end
end
