# frozen_string_literal: true

require "dry-initializer"
require "parallel"

module Mihari
  module Analyzers
    class Base
      extend Dry::Initializer

      include Mixins::Configurable
      include Mixins::Retriable

      attr_accessor :ignore_old_artifacts, :ignore_threshold

      def initialize(*args, **kwargs)
        super

        @ignore_old_artifacts = false
        @ignore_threshold = 0
      end

      # @return [Array<String>, Array<Mihari::Artifact>]
      def artifacts
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      # @return [String]
      def title
        self.class.to_s.split("::").last
      end

      # @return [String]
      def description
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      # @return [String]
      def source
        self.class.to_s.split("::").last
      end

      # @return [Array<String>]
      def tags
        []
      end

      #
      # Set artifacts & run emitters in parallel
      #
      # @return [nil]
      #
      def run
        set_unique_artifacts

        Parallel.each(valid_emitters) do |emitter|
          run_emitter emitter
        end
      end

      #
      # Run emitter
      #
      # @param [Mihari::Emitters::Base] emitter
      #
      # @return [nil]
      #
      def run_emitter(emitter)
        emitter.run(title: title, description: description, artifacts: unique_artifacts, source: source, tags: tags)
      rescue StandardError => e
        puts "Emission by #{emitter.class} is failed: #{e}"
      end

      def self.inherited(child)
        Mihari.analyzers << child
      end

      #
      # Normalize artifacts
      # - Uniquefy artifacts by native #uniq
      # - Convert data (string) into an artifact
      # - Reject an invalid artifact
      #
      # @return [Array<Mihari::Artifact>]
      #
      def normalized_artifacts
        @normalized_artifacts ||= artifacts.compact.uniq.sort.map do |artifact|
          # No need to set data_type manually
          # It is set automatically in #initialize
          artifact.is_a?(Artifact) ? artifact : Artifact.new(data: artifact, source: source)
        end.select(&:valid?)
      end

      private

      #
      # Uniquefy artifacts
      #
      # @return [Array<Mihari::Artifact>]
      #
      def unique_artifacts
        @unique_artifacts ||= normalized_artifacts.select do |artifact|
          artifact.unique?(ignore_old_artifacts: ignore_old_artifacts, ignore_threshold: ignore_threshold)
        end
      end

      #
      # Set unique artifacts
      #
      # @return [nil]
      #
      def set_unique_artifacts
        retry_on_error { unique_artifacts }
      rescue ArgumentError => _e
        klass = self.class.to_s.split("::").last.to_s
        raise Error, "Please configure #{klass} API settings properly"
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
        end
      end

      #
      # Normalize ASN value
      #
      # @param [String, Integer] asn
      #
      # @return [Integer]
      #
      def normalize_asn(asn)
        return asn if asn.is_a?(Integer)
        return asn.to_i unless asn.start_with?("AS")

        asn.delete_prefix("AS").to_i
      end
    end
  end
end
