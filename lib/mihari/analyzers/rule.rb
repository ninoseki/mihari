# frozen_string_literal: true

require "uuidtools"

module Mihari
  module Analyzers
    class Rule < Base
      option :title
      option :description
      option :queries

      option :id, default: proc {}
      option :tags, default: proc { [] }
      option :allowed_data_types, default: proc { ALLOWED_DATA_TYPES }
      option :disallowed_data_values, default: proc { [] }

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

          # Use #normalized_artifacts method to get atrifacts as Array<Mihari::Artifact>
          # So Mihari::Artifact object has "source" attribute (e.g. "Shodan")
          artifacts << analyzer.normalized_artifacts
        end

        artifacts.flatten
      end

      #
      # Normalize artifacts
      # - Uniquefy artifacts by #uniq(&:data)
      # - Reject an invalid artifact (for just in case)
      # - Select artifacts with allowed data types
      # - Reject artifacts with disallowed data values
      #
      # @return [Array<Mihari::Artifact>]
      #
      def normalized_artifacts
        @normalized_artifacts ||= artifacts.uniq(&:data).select(&:valid?).select do |artifact|
          allowed_data_types.include? artifact.data_type
        end.reject do |artifact|
          disallowed_data_value? artifact.data
        end
      end

      #
      # Disallowed data values in regexp
      #
      # @return [Array<Regexp>]
      #
      def disallowed_data_values_regexps
        @disallowed_data_values_regexps ||= disallowed_data_values.map { |v| Regexp.compile v }
      end

      #
      # Check whether a value is a disallowed data value or not
      #
      # @return [Boolean>]
      #
      def disallowed_data_value?(value)
        disallowed_data_values_regexps.any? { |regexp| regexp.match? value }
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
    end
  end
end
