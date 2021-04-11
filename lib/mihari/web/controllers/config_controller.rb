# frozen_string_literal: true

module Mihari
  module Controllers
    class ConfigController < BaseController
      get "/api/config" do
        report = Status.check

        json report.to_camelback_keys
      end
    end
  end
end
