# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Base class for analyzers
    #
    class Base < Actor
      # @return [String]
      attr_reader :query

      #
      # @param [String] query
      # @param [Hash, nil] options
      #
      def initialize(query, options: nil)
        super(options: options)

        @query = query
      end

      #
      # @return [Integer]
      #
      def pagination_interval
        options[:pagination_interval] || Mihari.config.pagination_interval
      end

      #
      # @return [Integer]
      #
      def pagination_limit
        options[:pagination_limit] || Mihari.config.pagination_limit
      end

      #
      # @return [Boolean]
      #
      def ignore_error?
        ignore_error = options[:ignore_error]
        return ignore_error unless ignore_error.nil?

        Mihari.config.ignore_error
      end

      # @return [Array<String>, Array<Mihari::Models::Artifact>]
      def artifacts
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # Normalize artifacts
      # - Convert data (string) into an artifact
      # - Reject an invalid artifact
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def normalized_artifacts
        artifacts.compact.sort.map do |artifact|
          # No need to set data_type manually
          # It is set automatically in #initialize
          artifact = artifact.is_a?(Models::Artifact) ? artifact : Models::Artifact.new(data: artifact)
          artifact.source = self.class.class_key
          artifact
        end.select(&:valid?).uniq(&:data)
      end

      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def call
        normalized_artifacts
      end

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
          %i[analyzer query].each { |key| copied.delete key }

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
