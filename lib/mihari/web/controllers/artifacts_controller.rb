# frozen_string_literal: true

module Mihari
  module Controllers
    class ArtifactsController < BaseController
      get "/api/artifacts/:id" do
        id = params["id"]
        id = id.to_s

        begin
          artifact = Mihari::Artifact.find(id)
        rescue ActiveRecord::RecordNotFound
          status 404

          return json({ message: "ID:#{id} is not found" })
        end

        json ArtifactSerializer.new(artifact).as_json
      end

      delete "/api/artifacts/:id" do
        id = params["id"]
        id = id.to_i

        begin
          alert = Mihari::Artifact.find(id)
          alert.delete

          status 204
          body ""
        rescue ActiveRecord::RecordNotFound
          status 404

          json({ message: "ID:#{id} is not found" })
        end
      end
    end
  end
end
