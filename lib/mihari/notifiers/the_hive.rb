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
        if artifacts.empty?
          puts "No unique artifacts given"
          return
        end

        res = api.create_alert(title: title, description: description, artifacts: artifacts.map(&:to_h))
        id = res.dig("id")
        puts "A new alret is created: id = #{id}"
      end
    end
  end
end
