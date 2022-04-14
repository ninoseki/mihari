# frozen_string_literal: true

module Mihari
  module Endpoints
    class Artifacts < Grape::API
      namespace :artifacts do
        desc "Get an artifact", {
          success: Entities::Artifact,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Get an artifact"
        }
        params do
          requires :id, type: Integer
        end
        get "/:id" do
          id = params[:id].to_i

          begin
            artifact = Mihari::Artifact.includes(
              :autonomous_system,
              :geolocation,
              :whois_record,
              :dns_records,
              :reverse_dns_names
            ).find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          # TODO: improve queries
          alert_ids = Mihari::Artifact.where(data: artifact.data).pluck(:alert_id)
          tag_ids = Mihari::Tagging.where(alert_id: alert_ids).pluck(:tag_id)
          tag_names = Mihari::Tag.where(id: tag_ids).distinct.pluck(:name)

          artifact.tags = tag_names

          present artifact, with: Entities::Artifact
        end

        desc "Enrich an artifact", {
          success: Entities::Message,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Enrich an artifact"
        }
        params do
          requires :id, type: Integer
        end
        get "/:id/enrich" do
          id = params["id"].to_i

          begin
            artifact = Mihari::Artifact.includes(
              :autonomous_system,
              :geolocation,
              :whois_record,
              :dns_records,
              :reverse_dns_names,
              :cpes,
              :ports
            ).find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          artifact.enrich_all
          artifact.save

          status 201
          present({ message: "" }, with: Entities::Message)
        end

        desc "Delete an artifact", {
          success: Entities::Message,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Delete an artifact"
        }
        params do
          requires :id, type: Integer
        end
        delete "/:id" do
          id = params["id"].to_i

          begin
            alert = Mihari::Artifact.find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          alert.destroy

          status 204
          present({ message: "" }, with: Entities::Message)
        end
      end
    end
  end
end
