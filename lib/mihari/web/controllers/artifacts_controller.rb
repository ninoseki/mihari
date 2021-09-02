# frozen_string_literal: true

module Mihari
  module Controllers
    class ArtifactsController < BaseController
      get "/api/artifacts/:id" do
        param :id, Integer, required: true

        id = params["id"].to_i

        begin
          artifact = Mihari::Artifact.includes(
            :autonomous_system,
            :geolocation,
            :whois_record,
            :dns_records,
            :reverse_dns_names
          ).find(id)
        rescue ActiveRecord::RecordNotFound
          status 404

          return json({ message: "ID:#{id} is not found" })
        end

        # TODO: improve queries
        alert_ids = Mihari::Artifact.where(data: artifact.data).pluck(:alert_id)
        tag_ids = Mihari::Tagging.where(alert_id: alert_ids).pluck(:tag_id)
        tag_names = Mihari::Tag.where(id: tag_ids).distinct.pluck(:name)

        artifact_json = Serializers::ArtifactSerializer.new(artifact).as_json

        # convert reverse DNS names into an array of string
        # also change it as nil if it is empty
        reverse_dns_names = (artifact_json[:reverse_dns_names] || []).filter_map { |v| v[:name] }
        reverse_dns_names = nil if reverse_dns_names.empty?
        artifact_json[:reverse_dns_names] = reverse_dns_names

        # change DNS records as nil if it is empty
        dns_records = artifact_json[:dns_records] || []
        dns_records = nil if dns_records.empty?
        artifact_json[:dns_records] = dns_records

        # set tags
        artifact_json[:tags] = tag_names

        json artifact_json
      end

      get "/api/artifacts/:id/enrich" do
        param :id, Integer, required: true

        id = params["id"].to_i

        begin
          artifact = Mihari::Artifact.includes(
            :autonomous_system,
            :geolocation,
            :whois_record,
            :dns_records,
            :reverse_dns_names
          ).find(id)
        rescue ActiveRecord::RecordNotFound
          status 404

          return json({ message: "ID:#{id} is not found" })
        end

        artifact.enrich_all
        artifact.save

        status 201
        body ""
      end

      delete "/api/artifacts/:id" do
        param :id, Integer, required: true

        id = params["id"].to_i

        begin
          alert = Mihari::Artifact.find(id)
          alert.delete

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
