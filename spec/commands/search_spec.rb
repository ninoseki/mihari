# frozen_string_literal: true

class SearchCLI < Mihari::CLI::Base
  include Mihari::Commands::Search
end

RSpec.describe Mihari::Commands::Search do
  include_context "with mocked logger"

  let!(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }
  let!(:yaml) { File.read path }
  let!(:rule) { Mihari::Rule.from_yaml yaml }

  describe "#search" do
    before do
      spy = spy(Mihari::Rule)
      allow(spy).to receive(:call).and_return FactoryBot.build(:alert, rule: rule.model)
      allow(Mihari::Rule).to receive(:new).and_return(spy)
    end

    it do
      expect { SearchCLI.start ["search", "-f", path] }.to output(include(rule.id)).to_stdout
    end
  end
end
