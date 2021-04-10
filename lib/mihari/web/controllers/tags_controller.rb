# frozen_string_literal: true

require "sinatra"

module Mihari
  module Controllers
    class TagsController < Sinatra::Base
      get "/api/tags" do
        tags = Mihari::Tag.distinct.pluck(:name)
        json tags
      end

      delete "/api/tags/:name" do
        name = params["name"]

        begin
          Mihari::Tag.where(name: name).destroy_all

          status 204
          body ""
        rescue ActiveRecord::RecordNotFound
          status 404

          message = { message: "Name:#{name} is not found" }
          json message
        end
      end
    end
  end
end
