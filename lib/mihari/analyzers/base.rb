# frozen_string_literal: true

module Mihari
  module Analyzers
    class Base
      extend Dry::Initializer

      option :rule, default: proc {}

      include Mixins::AutonomousSystem
      include Mixins::Configurable
      include Mixins::Retriable

      # @return [Mihari::Structs::Rule, nil]
      attr_reader :rule

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @base_time = Time.now.utc
      end

      #
      # Load/overwrite rule
      #
      # @param [String] path_or_id
      #
      def load_rule(path_or_id)
        @rule = Structs::Rule.from_path_or_id path_or_id
      end

      # @return [Array<String>, Array<Mihari::Artifact>]
      def artifacts
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      # @return [String]
      def source
        self.class.to_s.split("::").last.to_s
      end

      def class_name
        self.class.to_s.split("::").last
      end

      #
      # Set artifacts & run emitters in parallel
      #
      # @return [Mihari::Alert, nil]
      #
      def run
        raise ConfigurationError, "#{class_name} is not configured correctly" unless configured?

        alert_or_something = bulk_emit
        # returns Mihari::Alert created by the database emitter
        alert_or_something.find { |res| res.is_a?(Mihari::Alert) }
      end

      #
      # Bulk emitt
      #
      # @return [Array<Mihari::Alert>]
      #
      def bulk_emit
        Parallel.map(valid_emitters) { |emitter| emit emitter }.compact
      end

      #
      # Emit an alert
      #
      # @param [Mihari::Emitters::Base] emitter
      #
      # @return [Mihari::Alert, nil]
      #
      def emit(emitter)
        return if enriched_artifacts.empty?

        alert_or_something = emitter.run(artifacts: enriched_artifacts, rule: rule)

        Mihari.logger.info "Emission by #{emitter.class} is succedded"

        alert_or_something
      rescue StandardError => e
        Mihari.logger.info "Emission by #{emitter.class} is failed: #{e}"
      end

      class << self
        def inherited(child)
          super
          Mihari.analyzers << child
        end
      end

      #
      # Normalize artifacts
      # - Convert data (string) into an artifact
      # - Set rule ID
      # - Reject an invalid artifact
      # - Uniquefy artifacts by data
      #
      # @return [Array<Mihari::Artifact>]
      #
      def normalized_artifacts
        @normalized_artifacts ||= artifacts.compact.sort.map do |artifact|
          # No need to set data_type manually
          # It is set automatically in #initialize
          artifact = artifact.is_a?(Artifact) ? artifact : Artifact.new(data: artifact, source: source)
          artifact.rule_id = rule&.id
          artifact
        end.select(&:valid?).uniq(&:data)
      end

      private

      #
      # Uniquefy artifacts (assure rule level uniqueness)
      #
      # @return [Array<Mihari::Artifact>]
      #
      def unique_artifacts
        @unique_artifacts ||= normalized_artifacts.select do |artifact|
          artifact.unique?(base_time: @base_time, artifact_lifetime: rule&.artifact_lifetime)
        end
      end

      #
      # Enriched artifacts
      #
      # @return [Array<Mihari::Artifact>]
      #
      def enriched_artifacts
        @enriched_artifacts ||= Parallel.map(unique_artifacts) do |artifact|
          artifact.enrich_all
          artifact
        end
      end

      #
      # Select valid emitters
      #
      # @return [Array<Mihari::Emitters::Base>]
      #
      def valid_emitters
        @valid_emitters ||= Mihari.emitters.filter_map do |klass|
          emitter = klass.new
          emitter.valid? ? emitter : nil
        end.compact
      end
    end
  end
end
