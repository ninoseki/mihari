# frozen_string_literal: true

module Mihari
  module Analyzers
    ANALYZER_TO_CLASS = {
      "binaryedge" => BinaryEdge,
      "censys" => Censys,
      "circl" => CIRCL,
      "crtsh" => Crtsh,
      "dnstwister" => DNSTwister,
      "feed" => Feed,
      "greynoise" => GreyNoise,
      "hunterhow" => HunterHow,
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
      "misp" => Emitters::MISP,
      "slack" => Emitters::Slack,
      "the_hive" => Emitters::TheHive,
      "webhook" => Emitters::Webhook
    }.freeze

    class Rule
      include Mixins::FalsePositive

      # @return [Mihari::Services::Rule]
      attr_reader :rule

      # @return [Time]
      attr_reader :base_time

      #
      # @param [Mihari::Services::Rule] rule
      #
      def initialize(rule)
        @rule = rule
        @base_time = Time.now.utc

        validate_analyzer_configurations
      end

      #
      # Returns a list of artifacts matched with queries/analyzers (with the rule ID)
      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        analyzers.flat_map do |analyzer|
          result = analyzer.result

          raise result.failure if result.failure? && !analyzer.ignore_error?

          artifacts = result.value!
          artifacts.map do |artifact|
            artifact.rule_id = rule.id
            artifact
          end
        end
      end

      #
      # Normalize artifacts
      # - Reject invalid artifacts (for just in case)
      # - Select artifacts with allowed data types
      # - Reject artifacts with false positive values
      # - Set rule ID
      #
      # @return [Array<Mihari::Artifact>]
      #
      def normalized_artifacts
        valid_artifacts = artifacts.uniq(&:data).select(&:valid?)
        date_type_allowed_artifacts = valid_artifacts.select { |artifact| rule.data_types.include? artifact.data_type }
        date_type_allowed_artifacts.reject { |artifact| falsepositive? artifact.data }
      end

      #
      # Uniquify artifacts (assure rule level uniqueness)
      #
      # @return [Array<Mihari::Artifact>]
      #
      def unique_artifacts
        normalized_artifacts.select do |artifact|
          artifact.unique?(base_time: base_time, artifact_lifetime: rule.artifact_lifetime)
        end
      end

      #
      # Enriched artifacts
      #
      # @return [Array<Mihari::Artifact>]
      #
      def enriched_artifacts
        @enriched_artifacts ||= Parallel.map(unique_artifacts) do |artifact|
          rule.enrichers.each { |enricher| artifact.enrich_by_enricher enricher[:enricher] }
          artifact
        end
      end

      #
      # Bulk emit
      #
      # @return [Array<Mihari::Alert>]
      #
      def bulk_emit
        return [] if enriched_artifacts.empty?

        Parallel.map(valid_emitters) do |emitter|
          result = emitter.result

          Mihari.logger.info "Emission by #{emitter.class} is failed: #{result.failure}" if result.failure?
          Mihari.logger.info "Emission by #{emitter.class} is succeeded" if result.success?

          result.value_or nil
        end.compact
      end

      #
      # Set artifacts & run emitters in parallel
      #
      # @return [Mihari::Alert, nil]
      #
      def run
        alert_or_something = bulk_emit
        # returns Mihari::Alert created by the database emitter
        alert_or_something.find { |res| res.is_a?(Mihari::Alert) }
      end

      private

      #
      # Check whether a value is a falsepositive value or not
      #
      # @return [Boolean]
      #
      def falsepositive?(value)
        return true if rule.falsepositives.include?(value)

        regexps = rule.falsepositives.select { |fp| fp.is_a?(Regexp) }
        regexps.any? { |fp| fp.match?(value) }
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
      # @return [Array<Mihari::Analyzers::Base>]
      #
      def analyzers
        rule.queries.map do |query_params|
          analyzer_name = query_params[:analyzer]
          klass = get_analyzer_class(analyzer_name)
          klass.from_query(query_params)
        end
      end

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

      #
      # Deep copied emitters
      #
      # @return [Array<Mihari::Emitters::Base>]
      #
      def emitters
        rule.emitters.map(&:deep_dup).map do |params|
          name = params[:emitter]
          params.delete(:emitter)

          klass = get_emitter_class(name)
          klass.new(artifacts: enriched_artifacts, rule: rule, **params)
        end
      end

      #
      # @return [Array<Mihari::Emitters::Base>]
      #
      def valid_emitters
        emitters.select(&:valid?)
      end

      #
      # Validate configuration of analyzers
      #
      def validate_analyzer_configurations
        analyzers.map do |analyzer|
          next if analyzer.configured?

          message = "#{analyzer.source} is not configured correctly. #{analyzer.configuration_keys.join(", ")} is/are missing."
          raise ConfigurationError, message
        end
      end
    end
  end
end
