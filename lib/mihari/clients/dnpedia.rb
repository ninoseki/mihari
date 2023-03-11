# frozen_string_literal: true

require "json"
require "zlib"

module Mihari
  module Clients
    class DNPedia < Base
      DEFAULT_HEADERS = {
        "Accept-Encoding" => "gzip",
        "Referer" => "https://dnpedia.com/tlds/search.php",
        "X-Requested-With" => "XMLHttpRequest"
      }.freeze

      DEFAULT_PARAMS = {
        cmd: "search",
        columns: "id,name,zoneid,length,idn,thedate,",
        ecf: "name",
        ecv: "",
        days: 2,
        mode: "added",
        _search: false,
        nd: 1_569_842_920_216,
        rows: 500,
        page: 1,
        sidx: "length",
        sord: "asc"
      }.freeze

      #
      # @param [String] base_url
      # @param [Hash] headers
      #
      def initialize(base_url = "https://dnpedia.com", headers: {})
        headers = headers.merge(DEFAULT_HEADERS)

        super(base_url, headers: headers)
      end

      #
      # @param [String] keyword
      #
      def search(keyword)
        params = DEFAULT_PARAMS.merge({ ecv: normalize(keyword) })
        res = get("/tlds/ajax.php", params: params)

        sio = StringIO.new(res.body.to_s)
        gz = Zlib::GzipReader.new(sio)
        page = gz.read

        JSON.parse page
      end

      private

      def normalize(word)
        return word if word.start_with?("~")
        return word unless word.include?("%")

        "~#{word}"
      end
    end
  end
end
