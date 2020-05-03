# frozen_string_literal: true

require "active_record"

module Mihari
  class Tagging < ActiveRecord::Base
    belongs_to :alert
    belongs_to :tag
  end
end
