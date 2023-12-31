# frozen_string_literal: true

require "tempfile"

RSpec.describe Mihari::CLI::Alert do
  let_it_be(:alert) { FactoryBot.create(:alert) }
  let_it_be(:rule) { alert.rule }

  describe "#list" do
    it do
      expect { described_class.start ["list"] }.to output(include(alert.id.to_s)).to_stdout
    end
  end

  describe "#get" do
    it do
      expect { described_class.start ["get", alert.id.to_s] }.to output(include(alert.id.to_s)).to_stdout
    end
  end

  describe "#create" do
    before do
      @file = Tempfile.new("dummy")
      @file.write(YAML.dump({ rule_id: rule.id, artifacts: %w[1.1.1.1] }))
      @file.rewind
    end

    after do
      @file.unlink
    end

    it do
      expect { described_class.start ["create", @file.path] }.to output(include(rule.id)).to_stdout
    end
  end
end
