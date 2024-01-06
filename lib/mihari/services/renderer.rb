require "tilt/jbuilder"

module Mihari
  module Services
    #
    # Jbuilder based JSON renderer
    #
    class JbuilderRenderer < Service
      attr_reader :template

      #
      # @param [String] template
      # @param [Hash] params
      #
      # @return [String]
      #
      def call(template, params = {})
        @template = template

        jbuilder_template = Tilt::JbuilderTemplate.new { template_string }
        jbuilder_template.render(nil, params)
      end

      def template_string
        return File.read(template) if Pathname(template).exist?

        template
      end
    end
  end
end
