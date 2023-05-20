# frozen_string_literal: true

module Mihari
  module Analyzers
    class Base
      extend Dry::Initializer

      include Mixins::Configurable
      include Mixins::Retriable

      # @return [Array<String>, Array<Mihari::Artifact>]
      def artifacts
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # Normalize artifacts
      # - Convert data (string) into an artifact
      # - Reject an invalid artifact
      #
      # @return [Array<Mihari::Artifact>]
      #
      def normalized_artifacts
        retry_on_error do
          @normalized_artifacts ||= artifacts.compact.sort.map do |artifact|
            # No need to set data_type manually
            # It is set automatically in #initialize
            artifact = artifact.is_a?(Artifact) ? artifact : Artifact.new(data: artifact)
            artifact
          end.select(&:valid?).uniq(&:data).map do |artifact|
            # set source
            artifact.source = source
            artifact
          end
        end
      end

      # @return [String]
      def source
        self.class.to_s.split("::").last.to_s
      end

      # @return [String]
      def class_name
        self.class.to_s.split("::").last
      end

      class << self
        def inherited(child)
          super
          Mihari.analyzers << child
        end
      end
    end
  end
end
