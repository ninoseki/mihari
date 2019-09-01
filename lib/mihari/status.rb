# frozen_string_literal: true

module Mihari
  class Status
    def check
      {
        shodan: { status: shodan?, message: shodan },
        slack: { status: slack?, message: slack },
        censys: { status: censys?, message: censys },
        virustotal: { status: virustotal?, message: virustotal },
        onyphe: { status: onyphe?, message: onyphe },
        the_hive: { status: the_hive?, message: the_hive },
      }.map do |key, value|
        [key, convert(value)]
      end.to_h
    end

    def self.check
      new.check
    end

    private

    def convert(status:, message:)
      {
        status: status ? "OK" : "Bad",
        message: message
      }
    end

    def virustotal?
      ENV.key?("VIRUSTOTAL_API_KEY")
    end

    def virustotal
      virustotal? ? "VIRUSTOTAL_API_KEY is found" : "VIRUSTOTAL_API_KEY is missing"
    end

    def onyphe?
      ENV.key? "ONYPHE_API_KEY"
    end

    def onyphe
      onyphe? ? "ONYPHE_API_KEY is found" : "ONYPHE_API_KEY is missing"
    end

    def censys?
      ENV.key?("CENSYS_ID") && ENV.key?("CENSYS_SECRET")
    end

    def censys
      censys? ? "CENSYS_ID and CENSYS_SECRET are found" : "CENSYS_ID and CENSYS_SECRET are missing"
    end

    def shodan?
      ENV.key? "SHODAN_API_KEY"
    end

    def shodan
      shodan? ? "SHODAN_API_KEY is found" : "SHODAN_API_KEY is missing"
    end

    def slack?
      ENV.key? "SLACK_WEBHOOK_URL"
    end

    def slack
      slack? ? "SLACK_WEBHOOK_URL is found" : "SLACK_WEBHOOK_URL is missing"
    end

    def the_hive?
      ENV.key?("THEHIVE_API_ENDPOINT") && ENV.key?("THEHIVE_API_KEY")
    end

    def the_hive
      the_hive? ? "THEHIVE_API_ENDPOINT and THEHIVE_API_KEY are found" : "THEHIVE_API_ENDPOINT and THEHIVE_API_KEY are are missing"
    end
  end
end
