# frozen_string_literal: true

module Mihari
  module Emitters
    class TheHive < Base
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

      def config_keys
        %w(THEHIVE_API_ENDPOINT THEHIVE_API_KEY)
      end

      def the_hive
        @the_hive ||= Mihari::TheHive.new
      end

      def cache
        @cache ||= Cache.new
      end

      def save_as_cache(data)
        cache.save data
      end
    end
  end
end
