# frozen_string_literal: true

module Mihari
  module Endpoints
    class Tags < Grape::API
      namespace :tags do
        desc "Get tags", {
          is_array: true,
          success: Entities::Tags,
          summary: "Get tags"
        }
        get "/" do
          tags = Mihari::Tag.distinct.pluck(:name)
          present({ tags: tags }, with: Entities::Tags)
        end

        desc "Delete a tag", {
          success: Entities::Message,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Delete a tag"
        }
        params do
          requires :name, type: String
        end
        delete "/:name" do
          name = params[:name].to_s

          begin
            Mihari::Tag.where(name: name).destroy_all
          rescue ActiveRecord::RecordNotFound
            error!({ message: "Name:#{name} is not found" }, 404)
          end

          status 204
          present({ message: "" }, with: Entities::Message)
        end
      end
    end
  end
end
