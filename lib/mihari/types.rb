require "dry/types"

module Mihari
  module Types
    include Dry.Types()

    Int = Strict::Integer
    Nil = Strict::Nil
    Hash = Strict::Hash
    String = Strict::String
    Double = Strict::Float | Strict::Integer

    DataTypes = Types::String.enum(*ALLOWED_DATA_TYPES)

    AnalyzerTypes = Types::String.enum(
      "binaryedge",
      "censys",
      "circl",
      "dnpedia",
      "dnstwister",
      "onyphe",
      "otx",
      "passivetotal",
      "pulsedive",
      "securitytrails",
      "shodan",
      "virustotal_intelligence",
      "virustotal"
    )
  end
end
