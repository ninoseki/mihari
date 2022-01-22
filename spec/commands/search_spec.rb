# frozen_string_literal: true

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

    it do
      # it should not raise ArgumentError
      capture(:stdout) do
        CLI.start ["search", valid_rule]
      end
    end
  end
end
