# frozen_string_literal: true

module Mihari
  module Models
    #
    # DNS record model
    #
    class DnsRecord < ActiveRecord::Base
      belongs_to :artifact
    end
  end
end
