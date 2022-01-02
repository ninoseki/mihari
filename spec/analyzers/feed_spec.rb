# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Feed, :vcr do
  describe "#artifacts" do
    context "with JSON" do
      subject {
        described_class.new(
          "https://threatfox-api.abuse.ch/api/v1/",
          http_request_method: "POST",
          http_request_payload: { query: "get_iocs", days: 1 },
          http_request_type: "application/json",
          http_request_headers: {
            'api-key': ENV["THREATFOX_API_KEY"]
          },
          selector: "map(&:data).unwrap.map(&:ioc)"
        )
      }
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end

    context "with CSV" do
      subject {
        described_class.new(
          "https://urlhaus.abuse.ch/feeds/country/JP/",
          selector: "map { |v| v[1] }"
        )
      }
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end
end
