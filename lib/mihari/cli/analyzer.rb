# frozen_string_literal: true

require "mihari/commands/binaryedge"
require "mihari/commands/censys"
require "mihari/commands/circl"
require "mihari/commands/crtsh"
require "mihari/commands/dnpedia"
require "mihari/commands/dnstwister"
require "mihari/commands/onyphe"
require "mihari/commands/otx"
require "mihari/commands/passivetotal"
require "mihari/commands/pulsedive"
require "mihari/commands/securitytrails"
require "mihari/commands/shodan"
require "mihari/commands/spyse"
require "mihari/commands/urlscan"
require "mihari/commands/virustotal"
require "mihari/commands/zoomeye"

require "mihari/commands/json"

module Mihari
  module CLI
    class Analyzer < Base
      include Mihari::Mixins::Hash
      include Mixins::Utils

      include Mihari::Commands::BinaryEdge
      include Mihari::Commands::Censys
      include Mihari::Commands::CIRCL
      include Mihari::Commands::Crtsh
      include Mihari::Commands::DNPedia
      include Mihari::Commands::DNSTwister
      include Mihari::Commands::JSON
      include Mihari::Commands::Onyphe
      include Mihari::Commands::OTX
      include Mihari::Commands::PassiveTotal
      include Mihari::Commands::Pulsedive
      include Mihari::Commands::SecurityTrails
      include Mihari::Commands::Shodan
      include Mihari::Commands::Spyse
      include Mihari::Commands::Urlscan
      include Mihari::Commands::VirusTotal
      include Mihari::Commands::ZoomEye
    end
  end
end
