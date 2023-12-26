module Mihari
  module Services
    class RuleInitializer < Service
      #
      # @param [String] path
      # @param [Dry::Files] files
      #
      def call(path, files = Dry::Files.new)
        rule = Mihari::Rule.new(
          id: SecureRandom.uuid,
          title: "Title goes here",
          description: "Description goes here",
          created_on: Date.today,
          queries: []
        )
        files.write(path, rule.yaml)
      end
    end
  end
end
