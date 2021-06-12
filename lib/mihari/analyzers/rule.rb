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

      ANALYZER_TO_CLASS = {
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
          analyzer_name = params[:analyzer]
          klass = get_analyzer_class(analyzer_name)

          query = params[:query]
          analyzer = klass.new(query, **params)
          artifacts << analyzer.artifacts
        end

        artifacts.flatten
      end

      private

      #
      # Get analyzer class
      #
      # @param [String] analyzer_name
      #
      # @return [Class<Mihari::Analyzers::Base>] analyzer class
      #
      def get_analyzer_class(analyzer_name)
        analyzer = ANALYZER_TO_CLASS[analyzer_name]
        return analyzer if analyzer

        raise ArgumentError, "#{analyzer_name} is not supported"
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
