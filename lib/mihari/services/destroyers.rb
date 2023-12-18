module Mihari
  module Services
    class AlertDestroyer < Service
      #
      # @param [String] id
      #
      def call(id)
        Models::Alert.find(id).destroy
      end
    end

    class ArtifactDestroyer < Service
      #
      # @param [Integer] id
      #
      def call(id)
        Models::Artifact.find(id).destroy
      end
    end

    class RuleDestroyer < Service
      #
      # @param [String] id
      #
      def call(id)
        Models::Rule.find(id).destroy
      end
    end

    class TagDestroyer < Service
      #
      # @param [Integer] id
      #
      def call(id)
        Models::Tag.find(id).destroy
      end
    end
  end
end
