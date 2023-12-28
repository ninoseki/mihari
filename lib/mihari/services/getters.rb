module Mihari
  module Services
    class ArtifactGetter < Service
      #
      # @param [Integer] id
      #
      # @return [Mihari::Models::Artifact]
      #
      def call(id)
        Mihari::Models::Artifact.eager_load(
          :autonomous_system,
          :geolocation,
          :whois_record,
          :dns_records,
          :reverse_dns_names
        ).find id
      end
    end

    class AlertGetter < Service
      #
      # @param [Integer] id
      #
      # @return [Mihari::Models::Artifact]
      #
      def call(id)
        Mihari::Models::Alert.eager_load(
          :artifacts,
          rule: :tags
        ).find id
      end
    end

    class RuleGetter < Service
      #
      # @params [String] id
      #
      # @return [Mihari::Models::Rule]
      #
      def call(id)
        Mihari::Models::Rule.find id
      end
    end

    class IPGetter < Service
      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::MMDB::Response]
      #
      def call(ip)
        Mihari::Enrichers::MMDB.new.call ip
      end
    end
  end
end
