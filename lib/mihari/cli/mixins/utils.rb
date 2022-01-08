# frozen_string_literal: true

module Mihari
  module CLI
    module Mixins
      module Utils
        #
        # Send an exception notification if there is any error in a block
        #
        # @return [Nil]
        #
        def with_error_handling
          yield
        rescue StandardError => e
          notifier = Notifiers::ExceptionNotifier.new
          notifier.notify e
        end

        #
        # Check required keys in JSON
        #
        # @param [Hash] json
        #
        # @return [Boolean]
        #
        def required_alert_keys?(json)
          %w[title description artifacts].all? { |key| json.key? key }
        end

        #
        # Run analyzer
        #
        # @param [Class<Mihari::Analyzers::Base>] analyzer_class
        # @param [String] query
        # @param [Hash] options
        #
        # @return [nil]
        #
        def run_analyzer(analyzer_class, query:, options:)
          # options = Thor::CoreExt::HashWithIndifferentAccess
          # ref. https://www.rubydoc.info/github/wycats/thor/Thor/CoreExt/HashWithIndifferentAccess
          # so need to covert it to a plain hash
          hash_options = options.to_hash

          hash_options = symbolize_hash(hash_options)
          hash_options = normalize_options(hash_options)

          analyzer = analyzer_class.new(query, **hash_options)

          analyzer.ignore_old_artifacts = options[:ignore_old_artifacts] || false
          analyzer.ignore_threshold = options[:ignore_threshold] || 0

          analyzer.run
        end

        #
        # Normalize options (reject keys not for analyzers)
        #
        # @param [Hash] options
        #
        # @return [Hash]
        #
        def normalize_options(options)
          [:ignore_old_artifacts, :ignore_threshold].each do |ignore_key|
            options.delete(ignore_key)
          end
          options
        end
      end
    end
  end
end
