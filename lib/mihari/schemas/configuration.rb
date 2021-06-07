require "dry/schema"
require "dry/validation"

require "mihari/schemas/macros"

module Mihari
  module Schemas
    Configuration = Dry::Schema.Params do
      optional(:binaryedge_api_key).value(:string)
      optional(:censys_id).value(:string)
      optional(:censys_secret).value(:string)
      optional(:circl_passive_password).value(:string)
      optional(:circl_passive_username).value(:string)
      optional(:misp_api_endpoint).value(:string)
      optional(:misp_api_key).value(:string)
      optional(:onyphe_api_key).value(:string)
      optional(:otx_api_key).value(:string)
      optional(:passivetotal_api_key).value(:string)
      optional(:passivetotal_username).value(:string)
      optional(:pulsedive_api_key).value(:string)
      optional(:securitytrails_api_key).value(:string)
      optional(:shodan_api_key).value(:string)
      optional(:slack_channel).value(:string)
      optional(:slack_webhook_url).value(:string)
      optional(:spyse_api_key).value(:string)
      optional(:thehive_api_endpoint).value(:string)
      optional(:thehive_api_key).value(:string)
      optional(:urlscan_api_key).value(:string)
      optional(:virustotal_api_key).value(:string)
      optional(:zoomeye_api_key).value(:string)
      optional(:webhook_url).value(:string)
      optional(:webhook_use_json_body).value(:string)
      optional(:database).value(:string)
    end

    class ConfigurationContract < Dry::Validation::Contract
      params(Configuration)
    end
  end
end
