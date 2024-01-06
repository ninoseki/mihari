# frozen_string_literal: true

RSpec.describe Mihari::CLI::Tag do
  let_it_be(:rule) { FactoryBot.create(:rule) }
  let_it_be(:tag) { rule.tags.first }

  describe "#list" do
    it do
      expect { described_class.new.invoke(:list) }.to output(include(tag.name)).to_stdout
    end
  end

  describe "#list-transform" do
    it do
      expect do
        described_class.new.invoke(:list_transform, [], { template: "json.array! results.map(&:id)" })
      end.to output(include(tag.id.to_s)).to_stdout
    end
  end
end
