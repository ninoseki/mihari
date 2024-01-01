# frozen_string_literal: true

module Mihari
  module Models
    #
    # AS model
    #
    class AutonomousSystem < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
