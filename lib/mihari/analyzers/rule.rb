# frozen_string_literal: true

require "uuidtools"

NIL = nil

module Mihari
  module Analyzers
    class Rule < Base
      option :title
      option :description
      option :queries

      option :id, default: proc {}
      option :tags, default: proc { [] }
      option :allowed_data_types, default: proc { ALLOWED_DATA_TYPES }

      attr_reader :source

      def initialize(**kwargs)
        super(**kwargs)

        @source = id || UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, title + description).to_s
      end

      SERVICE_TO_ANALYZER = {
        "binaryedge" => BinaryEdge,
        "censys" => Censys,
        "circl" => CIRCL,
        "crtsh" => Crtsh,
        "dnpedia" => DNPedia,
        "dnstwister" => DNSTwister,
        "onyphe" => Onyphe,
        "otx" => OTX,
        "passivetotal" => PassiveTotal,
        "pulsedive" => Pulsedive,
        "securitytrails" => SecurityTrails,
        "shodan" => Shodan,
        "spyse" => Spyse,
        "urlscan" => Urlscan,
        "virustotal" => VirusTotal,
        "zoomeye" => ZoomEye
      }.freeze

      #
      # Returns a list of artifacts matched with queries
      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        artifacts = []

        queries.each do |params|
          service = params[:service]
          klass = service_to_analzer(service)

          query = params[:query]
          analyzer = klass.new(query, **params)
          artifacts << analyzer.artifacts
        end

        artifacts.flatten
      end

      private

      #
      # Convert service to analyzer class
      #
      # @param [String] service
      #
      # @return [Class] analyzer class
      #
      def service_to_analzer(service)
        analyzer = SERVICE_TO_ANALYZER[service]
        return analyzer if analyzer

        raise ArgumentError, "#{service} is not supported"
      end

      #
      # Select allowed artifacts
      #
      # @param [Array<Mihari::Artifact>] artifacts
      #
      # @return [Array<Mihari::Artifact>]
      #
      def select_allowed_artifacts(artifacts)
        artifacts.select do |artifact|
          allowed_data_types.include? artifact.data_type
        end
      end
    end
  end
end
