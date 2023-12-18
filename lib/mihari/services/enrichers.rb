module Mihari
  module Services
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
  end
end
