# frozen_string_literal: true

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Search
end

RSpec.describe Mihari::Commands::Search, :vcr do
  include_context "with mocked logger"

  before do
    allow(Parallel).to receive(:processor_count).and_return(0)
  end

  describe "#search" do
    let!(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }
    let!(:rule_id) do
      rule = YAML.safe_load_file(path)
      rule["id"]
    end

    it do
      expect { CLI.start ["search", "-f", path] }.to output(include(rule_id)).to_stdout
    end
  end
end
