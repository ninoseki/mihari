# frozen_string_literal: true

module Mihari
  module Analyzers
    class Base
      def initialize
        @the_hive = TheHive.new
        @cache = Cache.new
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

      # @return [Array<String>]
      def tags
        []
      end

      def run
        Mihari.emitters.each do |emitter_class|
          emitter = emitter_class.new
          next unless emitter.valid?

          run_emitter emitter
        end
      end

      def run_emitter(emitter)
        emitter.emit(title: title, description: description, artifacts: unique_artifacts, tags: tags)
      rescue StandardError => e
        puts "Emission by #{emitter.class} is failed: #{e}"
      end

      private

      # @return [Array<Mihari::Artifact>]
      def normalized_artifacts
        @normalized_artifacts ||= artifacts.map do |artifact|
          artifact.is_a?(Artifact) ? artifact : Artifact.new(artifact)
        end.select(&:valid?)
      end

      def uncached_artifacts
        @uncached_artifacts ||= normalized_artifacts.reject do |artifact|
          @cache.cached? artifact.data
        end
      end

      # @return [Array<Mihari::Artifact>]
      def unique_artifacts
        return uncached_artifacts unless @the_hive.valid?

        @unique_artifacts ||= @the_hive.artifact.find_non_existing_artifacts(uncached_artifacts)
      end
    end
  end
end
