# frozen_string_literal: true

module Mihari
  module Analyzers
    ANALYZER_TO_CLASS = {
      "binaryedge" => BinaryEdge,
      "censys" => Censys,
      "circl" => CIRCL,
      "crtsh" => Crtsh,
      "dnpedia" => DNPedia,
      "dnstwister" => DNSTwister,
      "feed" => Feed,
      "greynoise" => GreyNoise,
      "onyphe" => Onyphe,
      "otx" => OTX,
      "passivetotal" => PassiveTotal,
      "pt" => PassiveTotal,
      "pulsedive" => Pulsedive,
      "securitytrails" => SecurityTrails,
      "shodan" => Shodan,
      "st" => SecurityTrails,
      "urlscan" => Urlscan,
      "virustotal_intelligence" => VirusTotalIntelligence,
      "virustotal" => VirusTotal,
      "vt_intel" => VirusTotalIntelligence,
      "vt" => VirusTotal,
      "zoomeye" => ZoomEye
    }.freeze

    EMITTER_TO_CLASS = {
      "database" => Emitters::Database,
      "http" => Emitters::HTTP,
      "misp" => Emitters::MISP,
      "slack" => Emitters::Slack,
      "the_hive" => Emitters::TheHive,
      "webhook" => Emitters::Webhook
    }.freeze

    # @return [Mihari::Structs::Rule]
    attr_reader :rule

    class Rule < Base
      include Mixins::DisallowedDataValue

      def initialize(**kwargs)
        super(**kwargs)

        validate_analyzer_configurations
      end

      #
      # Returns a list of artifacts matched with queries
      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        artifacts = []

        rule.queries.each do |original_params|
          parmas = original_params.deep_dup

          analyzer_name = parmas[:analyzer]
          klass = get_analyzer_class(analyzer_name)

          query = parmas[:query]

          # set interval in the top level
          options = parmas[:options] || {}
          interval = options[:interval]

          parmas[:interval] = interval if interval

          # set rule
          parmas[:rule] = rule

          analyzer = klass.new(query, **parmas)

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
          rule.data_types.include? artifact.data_type
        end.reject do |artifact|
          disallowed_data_value? artifact.data
        end
      end

      #
      # Enriched artifacts
      #
      # @return [Array<Mihari::Artifact>]
      #
      def enriched_artifacts
        @enriched_artifacts ||= Parallel.map(unique_artifacts) do |artifact|
          rule.enrichers.each do |enricher|
            artifact.enrich_by_enricher(enricher[:enricher])
          end

          artifact
        end
      end

      #
      # Normalized disallowed data values
      #
      # @return [Array<Regexp, String>]
      #
      def normalized_disallowed_data_values
        @normalized_disallowed_data_values ||= rule.disallowed_data_values.map { |v| normalize_disallowed_data_value v }
      end

      #
      # Check whether a value is a disallowed data value or not
      #
      # @return [Boolean]
      #
      def disallowed_data_value?(value)
        return true if normalized_disallowed_data_values.include?(value)

        normalized_disallowed_data_values.select do |disallowed_data_value|
          disallowed_data_value.is_a?(Regexp)
        end.any? do |disallowed_data_value|
          disallowed_data_value.match?(value)
        end
      end

      private

      #
      # Get emitter class
      #
      # @param [String] emitter_name
      #
      # @return [Class<Mihari::Emitters::Base>] emitter class
      #
      def get_emitter_class(emitter_name)
        emitter = EMITTER_TO_CLASS[emitter_name]
        return emitter if emitter

        raise ArgumentError, "#{emitter_name} is not supported"
      end

      def valid_emitters
        @valid_emitters ||= rule.emitters.filter_map do |original_params|
          params = original_params.deep_dup

          name = params[:emitter]
          params.delete(:emitter)

          klass = get_emitter_class(name)
          emitter = klass.new(**params)

          emitter.valid? ? emitter : nil
        end
      end

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
      # Validate configuration of analyzers
      #
      def validate_analyzer_configurations
        rule.queries.each do |params|
          analyzer_name = params[:analyzer]
          klass = get_analyzer_class(analyzer_name)

          instance = klass.new("dummy")
          unless instance.configured?
            klass_name = klass.to_s.split("::").last
            raise ConfigurationError, "#{klass_name} is not configured correctly"
          end
        end
      end
    end
  end
end
