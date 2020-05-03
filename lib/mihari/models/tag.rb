# frozen_string_literal: true

require "active_record"

module Mihari
  class Tag < ActiveRecord::Base
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
  end
end
