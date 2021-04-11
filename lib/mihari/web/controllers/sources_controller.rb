# frozen_string_literal: true

module Mihari
  module Controllers
    class SourcesController < BaseController
      get "/api/sources" do
        tags = Mihari::Alert.distinct.pluck(:source)
        json tags
      end
    end
  end
end
