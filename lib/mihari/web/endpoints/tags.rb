# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Tag API endpoint
      #
      class Tags < Grape::API
        namespace :tags do
          desc "List tags", {
            is_array: true,
            success: Entities::Tags,
            summary: "List tags"
          }
          get "/" do
            tags = Mihari::Models::Tag.distinct.pluck(:name)
            present({ tags: tags }, with: Entities::Tags)
          end

          desc "Delete a tag", {
            success: { code: 204, model: Entities::Message },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Delete a tag"
          }
          params do
            requires :id, type: Integer
          end
          delete "/:id" do
            status 204

            id = params[:id].to_i
            result = Services::TagDestroyer.result(id)
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
