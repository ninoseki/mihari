# frozen_string_literal: true

module Mihari
  module Models
    #
    # Whois record model
    #
    class WhoisRecord < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
