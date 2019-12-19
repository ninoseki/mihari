# frozen_string_literal: true

RSpec.describe Mihari::Config do
  subject { described_class }

  describe ".load_from_yaml" do
    it do
      path = File.expand_path("./fixtures/test.yml", __dir__)
      subject.load_from_yaml path

      expect(ENV["VIRUSTOTAL_API_KEY"]).to eq("foo bar")
    end
  end
end
