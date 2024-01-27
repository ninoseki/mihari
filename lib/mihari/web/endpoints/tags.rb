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
            success: Entities::TagsWithPagination,
            summary: "List tags"
          }
          params do
            optional :q, type: String, default: ""
            optional :page, type: Integer, default: 1
            optional :limit, type: Integer, default: 10
          end
          get "/" do
            value = Services::TagSearcher.call(params.to_h)
            present(
              {
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              },
              with: Entities::TagsWithPagination
            )
          end

          desc "Delete a tag", {
            success: {code: 204, model: Entities::Message},
            failure: [{code: 404, model: Entities::ErrorMessage}],
            summary: "Delete a tag"
          }
          params do
            requires :id, type: Integer
          end
          delete "/:id" do
            status 204

            id = params[:id].to_i
            result = Services::TagDestroyer.result(id)
            return present({message: ""}, with: Entities::Message) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({message: "ID:#{id} not found"}, 404)
            end
            raise result.failure
          end
        end
      end
    end
  end
end
