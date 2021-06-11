# frozen_string_literal: true

require "cymbal"

module Mihari
  module CLI
    module Mixins
      module Utils
        def symbolize_hash(hash)
          Cymbal.symbolize hash
        end

        def with_error_handling
          yield
        rescue StandardError => e
          notifier = Notifiers::ExceptionNotifier.new
          notifier.notify e
        end

        # @return [true, false]
        def valid_json?(json)
          %w[title description artifacts].all? { |key| json.key? key }
        end

        def load_configuration
          config = options["config"]
          return unless config

          Mihari.load_config_from_yaml config
          Database.connect
        end

        def run_analyzer(analyzer_class, query:, options:)
          load_configuration

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

        def normalize_options(options)
          # Delete :config because it is not intended to use for running an analyzer
          [:config, :ignore_old_artifacts, :ignore_threshold].each do |ignore_key|
            options.delete(ignore_key)
          end
          options
        end
      end
    end
  end
end
