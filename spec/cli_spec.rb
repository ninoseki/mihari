# frozen_string_literal: true

RSpec.describe Mihari::CLI do
  subject { described_class }

  let(:query) { "test" }
  let(:mock) { double("Analyzer") }

  before { allow(mock).to receive(:run) }

  describe "#censys" do
    before { allow(Mihari::Analyzers::Censys).to receive(:new).and_return(mock) }

    it do
      subject.start ["censys", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#shodan" do
    before { allow(Mihari::Analyzers::Shodan).to receive(:new).and_return(mock) }

    it do
      subject.start ["shodan", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#onyphe" do
    before { allow(Mihari::Analyzers::Onyphe).to receive(:new).and_return(mock) }

    it do
      subject.start ["onyphe", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#urlscan" do
    before { allow(Mihari::Analyzers::Urlscan).to receive(:new).and_return(mock) }

    it do
      subject.start ["urlscan", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#alerts" do
    let(:mock) { double("AlertViewer") }
    let(:alerts) {
      [
        {
          "description": "test",
          "title": "test",
          "tags": ["test"],
          "createdAt": "2019-08-12 11:45:24 +0900",
          "artifacts": ["1.1.1.1"],
          "status": "New"
        }
      ]
    }

    before do
      allow(Mihari::AlertViewer).to receive(:new).and_return(mock)
      allow(mock).to receive(:list).and_return(alerts)
    end

    it do
      stdout = capture(:stdout){ subject.start ["alerts"] }.chomp
      expect(stdout).to eq(JSON.pretty_generate(alerts))
    end
  end

  describe "#parse_as_json" do
    subject { described_class.new }

    let(:json_string) { '{"a":1}' }

    it do
      res = subject.parse_as_json json_string
      expect(res).to eq("a" => 1)
    end

    context "when given an invalid input" do
      it do
        res = subject.parse_as_json("foo bar")
        expect(res).to eq(nil)
      end
    end
  end

  describe "#valid_json?" do
    subject { described_class.new }

    let(:json) {
      {
        "title" => "test",
        "description" => "test",
        "artifacts" => "test"
      }
    }

    it do
      expect(subject).to be_valid_json(json)
    end

    context "when given an invalid input" do
      it do
        expect(subject).not_to be_valid_json({})
      end
    end
  end
end
