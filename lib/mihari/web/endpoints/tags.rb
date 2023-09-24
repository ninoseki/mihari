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
          extend Dry::Monads[:result, :try]

          name = params[:name].to_s

          result = Try do
            Mihari::Tag.where(name: name).destroy_all
          end.to_result

          if result.success?
            status 204
            return present({ message: "" }, with: Entities::Message)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "Name:#{name} is not found" }, 404)
          else
            raise failure
          end
        end
      end
    end
  end
end
