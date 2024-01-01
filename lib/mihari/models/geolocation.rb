# frozen_string_literal: true

require "normalize_country"

module Mihari
  module Models
    #
    # Geolocation model
    #
    class Geolocation < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
