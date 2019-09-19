# frozen_string_literal: true

module Mihari
  module Emitters
    class TheHive < Base
      attr_reader :the_hive

      def initialize
        @the_hive = Mihari::TheHive.new
        @cache = Cache.new
      end

      # @return [true, false]
      def valid?
        the_hive.valid?
      end

      def emit(title:, description:, artifacts:, tags: [])
        return if artifacts.empty?

        the_hive.alert.create(
          title: title,
          description: description,
          artifacts: artifacts.map(&:to_h),
          tags: tags
        )

        save_as_cache artifacts.map(&:data)
      end

      private

      def save_as_cache(data)
        @cache.save data
      end
    end
  end
end
