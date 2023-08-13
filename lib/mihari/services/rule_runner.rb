# frozen_string_literal: true

module Mihari
  module Services
    class RuleRunner
      include Mixins::ErrorNotification

      # @return [Nihari::Services::RuleProxy]
      attr_reader :rule

      # @return [Boolean]
      attr_reader :force_overwrite

      def initialize(rule, force_overwrite:)
        @rule = rule
        @force_overwrite = force_overwrite
      end

      def force_overwrite?
        force_overwrite
      end

      #
      # @return [Boolean]
      #
      def diff?
        model = Mihari::Rule.find(rule.id)
        model.data != rule.data.deep_stringify_keys
      rescue ActiveRecord::RecordNotFound
        false
      end

      def update_or_create
        rule.to_model.save
      end

      def run
        begin
          analyzer = rule.to_analyzer
        rescue ConfigurationError => e
          # if there is a configuration error, output that error without the stack trace
          Mihari.logger.error e.to_s
          return
        end

        with_error_notification do
          alert = analyzer.run
          if alert.nil?
            Mihari.logger.info "There is no new artifact found"
            return
          end

          data = Mihari::Entities::Alert.represent(alert)
          puts JSON.pretty_generate(data.as_json)
        end
      end
    end
  end
end
