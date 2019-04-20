# frozen_string_literal: true

module Mihari
  module Notifiers
    class TheHive < Base
      attr_reader :api

      def initialize
        @api = Mihari::TheHive.new
      end

      def valid?
        api.valid?
      end

      def notify(title:, description:, artifacts:)
        return if artifacts.empty?

        api.create_alert(title: title, description: description, artifacts: artifacts.map(&:to_h))
      end
    end
  end
end
