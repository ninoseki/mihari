# frozen_string_literal: true

module Mihari
  module Controllers
    class SourcesController < BaseController
      get "/api/sources" do
        sources = Mihari::Alert.distinct.pluck(:source)
        json sources
      end
    end
  end
end
