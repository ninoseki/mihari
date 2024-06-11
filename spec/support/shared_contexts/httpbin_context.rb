# frozen_string_literal: true

require "capybara"
require "rspec/httpbin"

RSpec.shared_context "with fake HTTPBin" do
  let_it_be(:server) do
    server = Capybara::Server.new(RSpec::HTTPBin)
    server.boot
    server
  end
end
