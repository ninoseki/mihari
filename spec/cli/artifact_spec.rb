# frozen_string_literal: true

RSpec.describe Mihari::CLI::Artifact do
  let_it_be(:artifact) { FactoryBot.create(:artifact, :ip) }

  describe "#list" do
    it do
      expect { described_class.new.invoke(:list) }.to output(include(artifact.data)).to_stdout
    end
  end

  describe "#list-transform" do
    it do
      expect do
        described_class.new.invoke(:list_transform, [], { template: "json.array! results.map(&:id)" })
      end.to output(include(artifact.id.to_s)).to_stdout
    end
  end

  describe "#get" do
    it do
      expect { described_class.new.invoke(:get, [artifact.id.to_s]) }.to output(include(artifact.data)).to_stdout
    end
  end
end
