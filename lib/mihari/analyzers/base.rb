# frozen_string_literal: true

require "dry-initializer"
require "parallel"

module Mihari
  module Analyzers
    class Base
      extend Dry::Initializer

      include Configurable
      include Retriable

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

      def source
        self.class.to_s.split("::").last
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
        emitter.run(title: title, description: description, artifacts: unique_artifacts, source: source, tags: tags)
      rescue StandardError => e
        puts "Emission by #{emitter.class} is failed: #{e}"
      end

      def self.inherited(child)
        Mihari.analyzers << child
      end

      private

      # @return [Array<Mihari::Artifact>]
      def normalized_artifacts
        @normalized_artifacts ||= artifacts.compact.uniq.sort.map do |artifact|
          artifact.is_a?(Artifact) ? artifact : Artifact.new(data: artifact)
        end.select(&:valid?)
      end

      # @return [Array<Mihari::Artifact>]
      def unique_artifacts
        @unique_artifacts ||= normalized_artifacts.select do |artifact|
          artifact.unique?(ignore_old_artifacts: ignore_old_artifacts, ignore_threshold: ignore_threshold)
        end
      end

      def set_unique_artifacts
        retry_on_error { unique_artifacts }
      rescue ArgumentError => _e
        klass = self.class.to_s.split("::").last.to_s
        raise Error, "Please configure #{klass} API settings properly"
      end

      def valid_emitters
        @valid_emitters ||= Mihari.emitters.filter_map do |klass|
          emitter = klass.new
          emitter.valid? ? emitter : nil
        end
      end
    end
  end
end
