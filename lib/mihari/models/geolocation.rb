# frozen_string_literal: true

require "active_record"

module Mihari
  class Geolocation < ActiveRecord::Base
    has_one :artifact, dependent: :destroy
  end
end
