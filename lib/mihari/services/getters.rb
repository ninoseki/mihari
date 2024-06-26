# frozen_string_literal: true

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
      # @param [String] id
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
        Clients::MMDB.new.query ip
      end
    end
  end
end
