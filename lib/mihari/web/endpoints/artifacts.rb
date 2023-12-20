# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Artifact API endpoint
      #
      class Artifacts < Grape::API
        namespace :artifacts do
          desc "List/search artifacts", {
            is_array: true,
            success: Entities::ArtifactsWithPagination,
            summary: "List/search artifacts"
          }
          params do
            optional :q, type: String, default: ""
            optional :page, type: Integer, default: 1
            optional :limit, type: Integer, default: 10
          end
          get "/" do
            value = Services::ArtifactSearcher.call(params.to_h)
            present(
              {
                artifacts: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              },
              with: Entities::ArtifactsWithPagination
            )
          end

          desc "Get an artifact", {
            success: Entities::Artifact,
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Get an artifact"
          }
          params do
            requires :id, type: Integer
          end
          get "/:id" do
            id = params[:id].to_i
            result = Services::ArtifactGetter.result(id)
            return present(result.value!, with: Entities::Artifact) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} not found" }, 404)
            end
            raise result.failure
          end

          desc "Enrich an artifact", {
            success: { code: 201, model: Entities::Message },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Enrich an artifact"
          }
          params do
            requires :id, type: Integer
          end
          get "/:id/enrich" do
            status 201

            id = params["id"].to_i
            result = Services::ArtifactEnricher.result(id)
            return present({ message: "#{id} has been enriched" }, with: Entities::Message) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} not found" }, 404)
            end
            raise result.failure
          end

          desc "Delete an artifact", {
            success: { code: 204, model: Entities::Message },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Delete an artifact"
          }
          params do
            requires :id, type: Integer
          end
          delete "/:id" do
            status 204

            id = params["id"].to_i
            result = Services::ArtifactDestroyer.result(id)
            return present({ message: "" }, with: Entities::Message) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} not found" }, 404)
            end
            raise result.failure
          end
        end
      end
    end
  end
end
