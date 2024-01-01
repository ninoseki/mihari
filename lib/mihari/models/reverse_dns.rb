# frozen_string_literal: true

module Mihari
  module Models
    #
    # Reverse DNS name model
    #
    class ReverseDnsName < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
