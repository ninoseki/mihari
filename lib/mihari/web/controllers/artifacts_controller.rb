# frozen_string_literal: true

module Mihari
  module Controllers
    class ArtifactsController < BaseController
      get "/api/artifacts/:id" do
        param :id, Integer, required: true

        id = params["id"].to_i

        begin
          artifact = Mihari::Artifact.includes(
            :autonomous_system,
            :geolocation,
            :whois_record,
            :dns_records,
            :reverse_dns_names
          ).find(id)

          # TODO: improve queries
          alert_ids = Mihari::Artifact.where(data: artifact.data).pluck(:alert_id)
          tag_ids = Mihari::Tagging.where(alert_id: alert_ids).pluck(:tag_id)
          tag_names = Mihari::Tag.where(id: tag_ids).distinct.pluck(:name)
        rescue ActiveRecord::RecordNotFound
          status 404

          return json({ message: "ID:#{id} is not found" })
        end

        artifact_json = Serializers::ArtifactSerializer.new(artifact).as_json
        artifact_json[:tags] = tag_names

        json artifact_json
      end

      delete "/api/artifacts/:id" do
        param :id, Integer, required: true

        id = params["id"].to_i

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
