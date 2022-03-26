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

    DataTypes = Types::String.enum(*ALLOWED_DATA_TYPES)

    UrlscanDataTypes = Types::String.enum("ip", "domain", "url")

    HttpRequestMethods = Types::String.enum("GET", "POST")
    HttpRequestPayloadTypes = Types::String.enum("application/json", "application/x-www-form-urlencoded")

    EmitterTypes = Types::String.enum(
      "database",
      "webhook"
    )
  end
end
