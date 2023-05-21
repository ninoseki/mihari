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

      # @return [Mihari::Structs::Rule]
      attr_reader :rule

      # @return [Time]
      attr_reader :base_time

      #
      # @param [Mihari::Structs::Rule] rule
      #
      def initialize(rule:)
        @rule = rule
        @base_time = Time.now.utc

        validate_analyzer_configurations
      end

      #
      # Returns a list of artifacts matched with queries/analyzers
      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        analyzers.flat_map(&:normalized_artifacts)
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
        @normalized_artifacts ||= artifacts.uniq(&:data).select(&:valid?).select do |artifact|
          rule.data_types.include? artifact.data_type
        end.reject do |artifact|
          falsepositive? artifact.data
        end.map do |artifact|
          artifact.rule_id = rule.id
          artifact
        end
      end

      #
      # Uniquify artifacts (assure rule level uniqueness)
      #
      # @return [Array<Mihari::Artifact>]
      #
      def unique_artifacts
        @unique_artifacts ||= normalized_artifacts.select do |artifact|
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
          emission = emitter.emit
          Mihari.logger.info "Emission by #{emitter.class} is succeeded"
          emission
        rescue StandardError => e
          Mihari.logger.info "Emission by #{emitter.class} is failed: #{e}"
        end.compact
      end

      #
      # Set artifacts & run emitters in parallel
      #
      # @return [Mihari::Alert, nil]
      #
      def run
        # memoize enriched artifacts
        enriched_artifacts

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

        rule.falsepositives.select do |falsepositive|
          falsepositive.is_a?(Regexp)
        end.any? do |falseposistive|
          falseposistive.match?(value)
        end
      end

      #
      # Deep copied queries
      #
      # @return [Array<Hash>]
      #
      def queries
        rule.queries.map(&:deep_dup)
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
      # @return [Array<Mihari::Analyzers::Base>] <description>
      #
      def analyzers
        @analyzers ||= queries.map do |params|
          analyzer_name = params[:analyzer]
          klass = get_analyzer_class(analyzer_name)

          # set interval in the top level
          options = params[:options] || {}
          interval = options[:interval]
          params[:interval] = interval if interval

          # set rule
          params[:rule] = rule
          query = params[:query]

          analyzer = klass.new(query, **params)
          raise ConfigurationError, "#{analyzer.source} is not configured correctly" unless analyzer.configured?

          analyzer
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
        @valid_emitters ||= emitters.select(&:valid?)
      end

      #
      # Validate configuration of analyzers
      #
      def validate_analyzer_configurations
        # memoize analyzers & raise ConfigurationError if there is an analyzer which is not configured
        analyzers
      end
    end
  end
end
