# frozen_string_literal: true

module Mihari
  module Types
    include Dry.Types()

    Int = Strict::Integer
    Nil = Strict::Nil
    Hash = Strict::Hash
    String = Strict::String
    Bool = Strict::Bool
    Double = Strict::Float | Strict::Integer
    DateTime = Strict::DateTime

    DataTypes = Types::String.enum("hash", "ip", "domain", "url", "mail")

    HTTPRequestMethods = Types::String.enum("GET", "POST")
  end
end
