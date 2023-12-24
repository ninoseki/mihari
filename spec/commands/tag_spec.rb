# frozen_string_literal: true

class TagCLI < Mihari::CLI::Base
  include Mihari::Commands::Tag
end

RSpec.describe Mihari::Commands::Tag do
  include_context "with database fixtures"

  describe "#list" do
    let_it_be(:tag) { Mihari::Models::Tag.first }

    it do
      expect { TagCLI.start ["list"] }.to output(include(tag.name)).to_stdout
    end
  end
end
