# frozen_string_literal: true

require "thor"

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Search
end

RSpec.describe Mihari::Commands::Search, :vcr do
  before do
    # set an empty array as emitters (disable emission)
    allow(Mihari).to receive(:emitters).and_return([])
    # disable the parallel execution
    allow(Parallel).to receive(:processor_count).and_return(0)
  end

  describe "#search_by_rule" do
    let(:valid_rule) { File.expand_path("../fixtures/rules/valid_rule_does_not_need_api_key.yml", __dir__) }

    let(:invalid_config) { File.expand_path("../fixtures/configs/invalid_config.yml", __dir__) }
    let(:valid_config) { File.expand_path("../fixtures/configs/valid_config.yml", __dir__) }

    context "with invalid config" do
      it do
        capture(:stdout) do
          expect { CLI.start ["search", valid_rule, "--config", invalid_config] }.to raise_error(ArgumentError)
        end
      end
    end

    context "with valid config" do
      it do
        # it should not raise ArgumentError
        capture(:stdout) do
          CLI.start ["search", valid_rule, "--config", valid_config]
        end

        # configuration should be loaded correctly
        expect(Mihari.config.virustotal_api_key).to eq("foo bar")
      end
    end
  end
end
