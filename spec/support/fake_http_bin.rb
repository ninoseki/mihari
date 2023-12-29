require "forwardable"

class FakeHTTPBin
  extend Forwardable

  class << self
    def call(env)
      new(env).call
    end
  end

  attr_reader :req

  def initialize(env)
    @req = Rack::Request.new(env)
  end

  def_delegators :req, :content_type, :form_data?, :get?, :post?, :delete?, :url, :query_string, :path

  def call
    case path
    when "/get"
      get? ? ok_response : error_405
    when "/post"
      post? ? ok_response : error_405
    when "/delete"
      delete? ? ok_response : error_405
    else
      error_404
    end
  end

  def headers
    http_headers = req.env.select { |k, _v| k.start_with?("HTTP_") }
    http_headers.each_with_object({}) do |(k, v), a|
      a[k.sub(/^HTTP_/, "").downcase.gsub(/(^|_)\w/) { |word| word.upcase }.tr("_", "-")] = v
    end
  end

  def json?
    content_type == "application/json"
  end

  def origin
    req.env["REMOTE_ADDR"]
  end

  def body
    @body ||= req.body.read
  end

  def body_payload
    return {} if body == ""
    return { data: body, files: {}, form: {}, json: JSON.parse(body) } if json?
    return { data: "", files: {}, form: Rack::Utils.parse_nested_query(body), json: nil } if form_data?

    { data: body, files: {}, form: {}, json: nil }
  end

  def ok_response
    payload = body_payload.merge(args: query_string, headers: headers, origin: origin, url: url)

    ["200", { "Content-Type" => "application/json" }, [JSON.generate(payload)]]
    ["200", { "Content-Type" => "text/plain" }, [JSON.generate(payload)]]
  end

  def error_404
    ["404", { "Content-Type" => "application/json" }, [JSON.generate({})]]
  end

  def error_405
    ["405", { "Content-Type" => "application/json" }, [JSON.generate({})]]
  end
end
