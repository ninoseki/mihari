# frozen_string_literal: true

require "cymbal"
require "thor"

require "mihari/commands/mixins/utils"

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
require "mihari/commands/securitytrails_domain_feed"
require "mihari/commands/securitytrails"
require "mihari/commands/shodan"
require "mihari/commands/spyse"
require "mihari/commands/urlscan"
require "mihari/commands/virustotal"
require "mihari/commands/zoomeye"

require "mihari/commands/free_text"
require "mihari/commands/http_hash"
require "mihari/commands/passive_dns"
require "mihari/commands/passive_ssl"
require "mihari/commands/reverse_whois"
require "mihari/commands/ssh_fingerprint"

require "mihari/commands/config"
require "mihari/commands/json"
require "mihari/commands/web"

require "mihari/cli/mixins/utils"

module Mihari
  module CLI
    class Service < Thor
      include Mixins::Utils

      class_option :config, type: :string, desc: "Path to the config file"

      class_option :ignore_old_artifacts, type: :boolean, default: false, desc: "Whether to ignore old artifacts from checking or not. Only affects with analyze commands."
      class_option :ignore_threshold, type: :numeric, default: 0, desc: "Number of days to define whether an artifact is old or not. Only affects with analyze commands."

      include Mihari::Commands::BinaryEdge
      include Mihari::Commands::Censys
      include Mihari::Commands::CIRCL
      include Mihari::Commands::Config
      include Mihari::Commands::Crtsh
      include Mihari::Commands::DNPedia
      include Mihari::Commands::DNSTwister
      include Mihari::Commands::FreeText
      include Mihari::Commands::HTTPHash
      include Mihari::Commands::JSON
      include Mihari::Commands::Onyphe
      include Mihari::Commands::OTX
      include Mihari::Commands::PassiveDNS
      include Mihari::Commands::PassiveSSL
      include Mihari::Commands::PassiveTotal
      include Mihari::Commands::Pulsedive
      include Mihari::Commands::ReverseWhois
      include Mihari::Commands::SecurityTrails
      include Mihari::Commands::SecurityTrailsDomainFeed
      include Mihari::Commands::Shodan
      include Mihari::Commands::Spyse
      include Mihari::Commands::SSHFingerprint
      include Mihari::Commands::Urlscan
      include Mihari::Commands::VirusTotal
      include Mihari::Commands::Web
      include Mihari::Commands::ZoomEye

      class << self
        def exit_on_failure?
          true
        end
      end
    end
  end
end
