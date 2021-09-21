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

        param :asn, Integer
        param :dns_record, String
        param :dnsRecord, String
        param :reverse_dns_name, String
        param :reverseDnsName, String

        # set page & limit
        page = params["page"] || 1
        params["page"] = page.to_i

        limit = 10
        params["limit"] = 10

        # normalize keys
        params["artifact_data"] = params["artifact"]
        params["from_at"] = params["from_at"] || params["fromAt"]
        params["to_at"] = params["to_at"] || params["toAt"]
        params["dns_record"] = params["dns_record"] || params["dnsRecord"]
        params["reverse_dns_name"] = params["reverse_dns_name"] || params["reverseDnsName"]

        # symbolize hash keys
        filter = params.to_h.transform_keys(&:to_sym)

        search_filter_with_pagenation = Structs::Alert::SearchFilterWithPagination.new(**filter)
        alerts = Mihari::Alert.search(search_filter_with_pagenation)
        total = Mihari::Alert.count(search_filter_with_pagenation.without_pagination)

        json({ alerts: alerts, total: total, current_page: page, page_size: limit })
      end

      delete "/api/alerts/:id" do
        param :id, Integer, required: true

        id = params["id"].to_i

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
