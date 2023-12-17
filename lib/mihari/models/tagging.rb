# frozen_string_literal: true

module Mihari
  module Models
    #
    # Tagging model
    #
    class Tagging < ActiveRecord::Base
      belongs_to :rule
      belongs_to :tag
    end
  end
end
