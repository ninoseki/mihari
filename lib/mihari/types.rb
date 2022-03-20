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

    AnalyzerTypes = Types::String.enum(
      "binaryedge",
      "censys",
      "circl",
      "dnpedia",
      "dnstwister",
      "greynoise",
      "onyphe",
      "otx",
      "passivetotal",
      "pt",
      "pulsedive",
      "securitytrails",
      "shodan",
      "st",
      "virustotal_intelligence",
      "virustotal",
      "vt_intel",
      "vt"
    )

    HttpRequestMethods = Types::String.enum("GET", "POST")
    HttpRequestPayloadTypes = Types::String.enum("application/json", "application/x-www-form-urlencoded")

    EmitterTypes = Types::String.enum(
      "database",
      "http",
      "misp",
      "slack",
      "the_hive",
      "webhook"
    )
  end
end
