# frozen_string_literal: true

module Mihari
  module Emitters
    class TheHive < Base
      attr_reader :api

      def initialize
        @api = Mihari::TheHive.new
      end

      # @return [true, false]
      def valid?
        api.valid?
      end

      def emit(title:, description:, artifacts:, tags: [])
        return if artifacts.empty?

        api.create_alert(
          title: title,
          description: description,
          artifacts: artifacts.map(&:to_h),
          tags: tags
        )
      end
    end
  end
end
