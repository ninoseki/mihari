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
      def class_name
        self.class.to_s.split("::").last
      end

      alias_method :source, :class_name

      class << self
        #
        # Initialize an analyzer by query params
        #
        # @param [Hash] params
        #
        # @return [Mihari::Analyzers::Base]
        #
        def from_query(params)
          # get options and set default value as an empty hash
          options = params[:options] || {}

          # set interval in the top level
          interval = options[:interval]
          params[:interval] = interval if interval

          query = params[:query]

          new(query, **params)
        end

        def inherited(child)
          super
          Mihari.analyzers << child
        end
      end
    end
  end
end
