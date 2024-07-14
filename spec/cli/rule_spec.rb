# frozen_string_literal: true

RSpec.describe Mihari::CLI::Rule do
  let_it_be(:rule) { FactoryBot.create(:rule) }

  describe "#rule" do
    let!(:path) { "/tmp/#{SecureRandom.uuid}.yml" }

    after { FileUtils.rm path, force: true }

    it do
      expect do
        described_class.new.invoke(:init, [path])
      end.not_to output.to_stdout
    end
  end

  describe "#validate" do
    let!(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }

    it do
      expect { described_class.new.invoke(:validate, [path]) }.not_to output.to_stdout
    end

    context "with invalid rule" do
      let!(:path) { File.expand_path("../fixtures/rules/invalid_rule.yml", __dir__) }

      it do
        expect do
          expect { described_class.new.invoke(:validate, [path]) }.to output(include(path)).to_stderr
        end.to raise_error(SystemExit) # ref. https://pocke.hatenablog.com/entry/2016/07/17/085928
      end
    end
  end

  describe "#list" do
    it do
      expect { described_class.new.invoke(:list) }.to output(include(rule.id)).to_stdout
    end
  end

  describe "#list-transform" do
    it do
      expect do
        described_class.new.invoke(:list_transform, [], {template: "json.array! results.map(&:id)"})
      end.to output(include(rule.id.to_s)).to_stdout
    end
  end

  describe "#get" do
    it do
      expect { described_class.new.invoke(:get, [rule.id]) }.to output(include(rule.id)).to_stdout
    end
  end
end
