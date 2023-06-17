require "http"
require "json"
require "yaml"

def recursive_delete(hash, to_remove)
  hash.delete(to_remove)
  hash.each_value do |value|
    recursive_delete(value, to_remove) if value.is_a? Hash
  end
end

res = HTTP.get("http://localhost:9292/api/swagger_doc")
json = JSON.parse(res.body.to_s)

# remove host and operationId because
# - host: can be varied
# - operationId: is useless (to me)
keys_to_remove = ["host", "operationId"]
keys_to_remove.each do |key|
  recursive_delete json, key
end

puts json.to_yaml
