# frozen_string_literal: true

module Mihari
  module Analyzers
    class Base
      include Mixins::Configurable
      include Mixins::Retriable

      # @return [String]
      attr_reader :query

      # @return [Hash]
      attr_reader :options

      #
      # @param [String] query
      # @param [Hash, nil] options
      #
      def initialize(query, options: nil)
        @query = query
        @options = options || {}
      end

      #
      # @return [Integer, nil]
      #
      def interval
        @interval = options[:interval]
      end

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
          copied = params.deep_dup

          # convert params into arguments for initialization
          query = copied[:query]

          # delete analyzer and query
          %i[analyzer query].each do |key|
            copied.delete key
          end

          copied[:options] = copied[:options] || nil

          new(query, **copied)
        end

        def inherited(child)
          super
          Mihari.analyzers << child
        end
      end
    end
  end
end
