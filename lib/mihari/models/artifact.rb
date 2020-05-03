# frozen_string_literal: true

require "active_record"

class ArtifactValidator < ActiveModel::Validator
  def validate(record)
    return if record.data_type

    record.errors[:data] << "#{record.data} is not supported"
  end
end

module Mihari
  class Artifact < ActiveRecord::Base
    include ActiveModel::Validations
    validates_with ArtifactValidator

    def initialize(attributes)
      super
      self.data_type = TypeChecker.type(data)
    end

    def unique?
      self.class.find_by(data: data).nil?
    end
  end
end
