# frozen_string_literal: true

module Mihari
  module Notifiers
    class TheHive < Base
      attr_reader :api

      def initialize
        @api = Mihari::TheHive.new
      end

      # @return [true, false]
      def valid?
        api.valid?
      end

      def notify(title:, description:, artifacts:, tags: [])
        return if artifacts.empty?

        res = api.create_alert(
          title: title,
          description: description,
          artifacts: artifacts.map(&:to_h),
          tags: tags
        )
        id = res.dig("id")
        puts "A new alret is created. (id: #{id})"
      end
    end
  end
end
