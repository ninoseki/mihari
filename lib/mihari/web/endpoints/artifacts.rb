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
          extend Dry::Monads[:result, :try]

          id = params[:id].to_i

          result = Try do
            artifact = Mihari::Models::Artifact.includes(
              :autonomous_system,
              :geolocation,
              :whois_record,
              :dns_records,
              :reverse_dns_names
            ).find(id)
            # TODO: improve queries
            alert_ids = Mihari::Models::Artifact.where(data: artifact.data).pluck(:alert_id)
            tag_ids = Mihari::Models::Tagging.where(alert_id: alert_ids).pluck(:tag_id)
            tag_names = Mihari::Models::Tag.where(id: tag_ids).distinct.pluck(:name)

            artifact.tags = tag_names

            artifact
          end.to_result

          return present(result.value!, with: Entities::Artifact) if result.success?

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          else
            raise failure
          end
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
          extend Dry::Monads[:result, :try]

          id = params["id"].to_i

          result = Try do
            artifact = Mihari::Models::Artifact.includes(
              :autonomous_system,
              :geolocation,
              :whois_record,
              :dns_records,
              :reverse_dns_names,
              :cpes,
              :ports
            ).find(id)

            artifact.enrich_all
            artifact.save
          end.to_result

          if result.success?
            status 201
            return present({ message: "" }, with: Entities::Message)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          else
            raise failure
          end
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
          extend Dry::Monads[:result, :try]

          id = params["id"].to_i

          result = Try do
            alert = Mihari::Models::Artifact.find(id)
            alert.destroy
          end.to_result

          if result.success?
            status 204
            return present({ message: "" }, with: Entities::Message)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          else
            raise failure
          end
        end
      end
    end
  end
end
