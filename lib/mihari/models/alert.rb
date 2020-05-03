# frozen_string_literal: true

require "active_record"

module Mihari
  class Alert < ActiveRecord::Base
    has_many :taggings, dependent: :destroy
    has_many :artifacts, dependent: :destroy
    has_many :tags, through: :taggings
  end
end
