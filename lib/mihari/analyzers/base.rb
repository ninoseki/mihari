# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class Base
      include Configurable
      include Retriable

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

      # @return [Array<String>]
      def tags
        []
      end

      def run
        set_unique_artifacts

        Parallel.each(valid_emitters) do |emitter|
          run_emitter emitter
        end
      end

      def run_emitter(emitter)
        emitter.run(title: title, description: description, artifacts: unique_artifacts, tags: tags)
      rescue StandardError => e
        puts "Emission by #{emitter.class} is failed: #{e}"
      end

      def self.inherited(child)
        Mihari.analyzers << child
      end

      private

      def the_hive
        @the_hive ||= TheHive.new
      end

      def cache
        @cache ||= Cache.new
      end

      # @return [Array<Mihari::Artifact>]
      def normalized_artifacts
        @normalized_artifacts ||= artifacts.compact.uniq.sort.map do |artifact|
          artifact.is_a?(Artifact) ? artifact : Artifact.new(artifact)
        end.select(&:valid?)
      end

      def uncached_artifacts
        @uncached_artifacts ||= normalized_artifacts.reject do |artifact|
          cache.cached? artifact.data
        end
      end

      # @return [Array<Mihari::Artifact>]
      def unique_artifacts
        return uncached_artifacts unless the_hive.valid?

        @unique_artifacts ||= the_hive.artifact.find_non_existing_artifacts(uncached_artifacts)
      end

      def set_unique_artifacts
        retry_on_error { unique_artifacts }
      rescue ArgumentError => _e
        klass = self.class.to_s.split("::").last.to_s
        raise Error, "Please configure #{klass} API settings properly"
      end

      def valid_emitters
        @valid_emitters ||= Mihari.emitters.map do |klass|
          emitter = klass.new
          emitter.valid? ? emitter : nil
        end.compact
      end
    end
  end
end
