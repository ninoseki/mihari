# frozen_string_literal: true

module Mihari
  module Models
    #
    # CPE model
    #
    class CPE < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
