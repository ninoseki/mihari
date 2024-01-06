# frozen_string_literal: true

class SearchCLI < Mihari::CLI::Base
  include Mihari::Commands::Search
end

RSpec.describe Mihari::Commands::Search, :vcr do
  include_context "with mocked logger"

  let!(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }
  let!(:yaml) { File.read path }
  let!(:rule) { Mihari::Rule.from_yaml yaml }

  before do
    double = class_double(Mihari::Services::WhoisRecordBuilder)
    allow(double).to receive(:call).and_return(nil)

    allow(Parallel).to receive(:processor_count).and_return(0)
  end

  describe "#search" do
    it do
      expect { SearchCLI.new.invoke(:search, [path], { force_overwrite: true }) }.to output(include(rule.id)).to_stdout
    end
  end
end
