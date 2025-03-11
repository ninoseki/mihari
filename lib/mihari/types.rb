# frozen_string_literal: true

module Mihari
  #
  # dry-type based types
  #
  module Types
    include Dry.Types()

    Int = Strict::Integer
    Nil = Strict::Nil
    Hash = Strict::Hash
    String = Strict::String
    Bool = Strict::Bool
    Double = Strict::Float | Strict::Integer
    DateTime = Strict::DateTime

    NetworkDataTypes = Types::String.enum("ip", "domain", "url")
    DataTypes = Types::String.enum(
      *[NetworkDataTypes.values, "hash", "mail"].flatten
    )

    HTTPRequestMethods = Types::String.enum("GET", "POST")
  end
end
