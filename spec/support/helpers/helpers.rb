# frozen_string_literal: true

# rubocop:disable Style/EvalWithLocation, Security/Eval
module Spec
  module Support
    module Helpers
      def capture(stream)
        begin
          stream = stream.to_s
          eval "$#{stream} = StringIO.new"
          yield
          result = eval("$#{stream}").string
        ensure
          eval("$#{stream} = #{stream.upcase}")
        end
        result
      end

      def reset_db
        Mihari::Alert.destroy_all
        Mihari::Artifact.destroy_all
        Mihari::Tagging.destroy_all
        Mihari::Tag.destroy_all
        Mihari::Rule.destroy_all
      end
    end
  end
end
# rubocop:enable Style/EvalWithLocation, Security/Eval
