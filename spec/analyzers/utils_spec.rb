class TestAnalyzer
  include Mihari::Analyzers::Mixins::Utils
end

RSpec.describe TestAnalyzer do
  describe "#refang" do
    subject { described_class.new }

    it do
      expect(subject.refang("1.1.1.1")).to eq("1.1.1.1")
    end

    it do
      expect(subject.refang("1.1.1[.]1")).to eq("1.1.1.1")
    end

    it do
      expect(subject.refang("1.1.1(.)1")).to eq("1.1.1.1")
    end
  end
end
