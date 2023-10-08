# frozen_string_literal: true

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Search
end

RSpec.describe Mihari::Commands::Search, :vcr do
  before do
    # set an empty array as emitters (disable emission)
    allow(Mihari).to receive(:emitters).and_return([])
    allow(Mihari).to receive(:enrichers).and_return([])
    # disable the parallel execution
    allow(Parallel).to receive(:processor_count).and_return(0)
  end

  describe "#search" do
    let(:rule) { File.expand_path("../fixtures/rules/valid_rule_does_not_need_api_key.yml", __dir__) }

    it do
      expect do
        expect do
          CLI.start ["search", rule]
          SemanticLogger.flush
        end.to output(/test/).to_stdout
        # "test" is a rule ID
        # it should be included in the output
      end.to output.to_stderr
    end
  end
end
