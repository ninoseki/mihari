# frozen_string_literal: true

class TagCLI < Mihari::CLI::Base
  include Mihari::Commands::Tag
end

RSpec.describe Mihari::Commands::Tag do
  let_it_be(:rule) { FactoryBot.create(:rule) }
  let_it_be(:tag) { rule.tags.first }

  describe "#list" do
    it do
      expect { TagCLI.start ["list"] }.to output(include(tag.name)).to_stdout
    end
  end
end
