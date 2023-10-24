# frozen_string_literal: true

module Mihari
  module Models
    class Tag < ActiveRecord::Base
      has_many :taggings, dependent: :destroy
      has_many :tags, through: :taggings
    end
  end
end
