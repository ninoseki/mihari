# frozen_string_literal: true

module Mihari
  module Controllers
    class AlertsController < BaseController
      get "/api/alerts" do
        param :page, Integer
        param :artifact, String
        param :description, String
        param :source, String
        param :tag, String

        param :from_at, DateTime
        param :fromAt, DateTime
        param :to_at, DateTime
        param :toAt, DateTime

        page = params["page"] || 1
        page = page.to_i
        limit = 10

        artifact_data = params["artifact"]
        description = params["description"]
        source = params["source"]
        tag_name = params["tag"]
        title = params["title"]

        from_at = params["from_at"] || params["fromAt"]
        from_at = DateTime.parse(from_at) if from_at
        to_at = params["to_at"] || params["toAt"]
        to_at = DateTime.parse(to_at) if to_at

        alerts = Mihari::Alert.search(
          artifact_data: artifact_data,
          description: description,
          from_at: from_at,
          limit: limit,
          page: page,
          source: source,
          tag_name: tag_name,
          title: title,
          to_at: to_at
        )
        total = Mihari::Alert.count(
          artifact_data: artifact_data,
          description: description,
          from_at: from_at,
          source: source,
          tag_name: tag_name,
          title: title,
          to_at: to_at
        )

        json({ alerts: alerts, total: total, current_page: page, page_size: limit })
      end

      delete "/api/alerts/:id" do
        id = params["id"]
        id = id.to_i

        begin
          alert = Mihari::Alert.find(id)
          alert.destroy

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
