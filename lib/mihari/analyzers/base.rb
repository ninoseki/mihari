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
        unique_artifacts = normalized_artifacts.reject do |artifact|
          reject_exists_ones & the_hive.valid? && the_hive.exists?(data: artifact.data, data_type: artifact.data_type)
        end

        Mihari.notifiers.each do |notifier_class|
          notifier = notifier_class.new
          next unless notifier.valid?

          begin
            notifier.notify(title: title, description: description, artifacts: unique_artifacts, tags: tags)
          rescue StandardError => e
            puts "Sending notification by #{notifier.class} is failed: #{e}"
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
    end
  end
end
