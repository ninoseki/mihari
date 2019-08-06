# frozen_string_literal: true

module Mihari
  module Analyzers
    class Base
      attr_reader :the_hive

      def initialize
        @the_hive = TheHive.new
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

      def run(reject_exists_ones: true)
        artifacts = reject_exists_ones ? unique_artifacts : normalized_artifacts

        Mihari.emitters.each do |emitter_class|
          emitter = emitter_class.new
          next unless emitter.valid?

          begin
            emitter.emit(title: title, description: description, artifacts: artifacts, tags: tags)
          rescue StandardError => e
            puts "Sending notification by #{emitter.class} is failed: #{e}"
          end
        end
      end

      private

      # @return [Array<Mihari::Artifact>]
      def normalized_artifacts
        artifacts.map do |artifact|
          artifact.is_a?(Artifact) ? artifact : Artifact.new(artifact)
        end.select(&:valid?)
      end

      # @return [Array<Mihari::Artifact>]
      def unique_artifacts
        normalized_artifacts.reject do |artifact|
          the_hive.valid? && the_hive.exists?(data: artifact.data, data_type: artifact.data_type)
        end
      end
    end
  end
end
