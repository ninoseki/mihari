# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Artifact API endpoint
      #
      class Artifacts < Grape::API
        class ArtifactGetter < Service
          #
          # @param [Integer] id
          #
          # @return [Mihari::Models::Artifact]
          #
          def call(id)
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
          end
        end

        class ArtifactEnricher < Service
          #
          # @param [String] id
          #
          def call(id)
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
          end
        end

        class ArtifactDestroyer < Service
          #
          # @param [Integer] id
          #
          def call(id)
            Mihari::Models::Artifact.find(id).destroy
          end
        end

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
            result = ArtifactGetter.result(id)
            return present(result.value!, with: Entities::Artifact) if result.success?

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise failure
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
            result = ArtifactEnricher.result(id)
            if result.success?
              status 201
              return present({ message: "" }, with: Entities::Message)
            end

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise failure
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
            result = ArtifactDestroyer.result(id)
            if result.success?
              status 204
              return present({ message: "" }, with: Entities::Message)
            end

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise failure
          end
        end
      end
    end
  end
end
