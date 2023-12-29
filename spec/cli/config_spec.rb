RSpec.describe Mihari::CLI::Config do
  let!(:key) { Mihari.config.keys.first }

  describe "#list" do
    it do
      expect { described_class.start ["list"] }.to output(include(key)).to_stdout
    end
  end
end
