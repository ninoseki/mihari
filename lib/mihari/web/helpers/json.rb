# frozen_string_literal: true

require "awrence"
require "multi_json"
require "sinatra/base"

module Sinatra
  module JSON
    class << self
      def encode(object)
        ::MultiJson.dump(object)
      end
    end

    def json(object, options = {})
      object = object.to_camelback_keys

      content_type resolve_content_type(options)
      resolve_encoder_action object, resolve_encoder(options)
    end

    private

    def resolve_content_type(options = {})
      options[:content_type] || settings.json_content_type
    end

    def resolve_encoder(options = {})
      options[:json_encoder] || settings.json_encoder
    end

    def resolve_encoder_action(object, encoder)
      [:encode, :generate].each do |method|
        return encoder.send(method, object) if encoder.respond_to? method
      end

      if encoder.is_a? Symbol
        object.__send__(encoder)
      else
        fail "#{encoder} does not respond to #generate nor #encode"
      end
    end
  end

  Base.set :json_encoder do
    ::MultiJson
  end

  Base.set :json_content_type, :json

  # Load the JSON helpers in modular style automatically
  Base.helpers JSON
end
