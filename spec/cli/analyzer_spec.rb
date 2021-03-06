# frozen_string_literal: true

RSpec.describe Mihari::CLI::Analyzer do
  subject { described_class }

  let(:query) { "test" }
  let(:mock) { double("Analyzer") }

  before do
    allow(mock).to receive(:run)
    allow(mock).to receive(:artifacts)
    allow(mock).to receive(:ignore_threshold=)
    allow(mock).to receive(:ignore_old_artifacts=)
  end

  describe ".exit_on_failure?" do
    it do
      expect(subject.exit_on_failure?).to eq(true)
    end
  end

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

  describe "#virustotal" do
    before { allow(Mihari::Analyzers::VirusTotal).to receive(:new).and_return(mock) }

    it do
      subject.start ["virustotal", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#securitytrails" do
    before { allow(Mihari::Analyzers::SecurityTrails).to receive(:new).and_return(mock) }

    it do
      subject.start ["securitytrails", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#crtsh" do
    before { allow(Mihari::Analyzers::Crtsh).to receive(:new).and_return(mock) }

    it do
      subject.start ["crtsh", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#dnpedia" do
    before { allow(Mihari::Analyzers::DNPedia).to receive(:new).and_return(mock) }

    it do
      subject.start ["dnpedia", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#circl" do
    before { allow(Mihari::Analyzers::CIRCL).to receive(:new).and_return(mock) }

    it do
      subject.start ["circl", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#passivetotal" do
    before { allow(Mihari::Analyzers::PassiveTotal).to receive(:new).and_return(mock) }

    it do
      subject.start ["passivetotal", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#zoomeye" do
    before { allow(Mihari::Analyzers::ZoomEye).to receive(:new).and_return(mock) }

    it do
      subject.start ["zoomeye", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#binaryedge" do
    before { allow(Mihari::Analyzers::BinaryEdge).to receive(:new).and_return(mock) }

    it do
      subject.start ["binaryedge", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#pulsedive" do
    before { allow(Mihari::Analyzers::Pulsedive).to receive(:new).and_return(mock) }

    it do
      subject.start ["pulsedive", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#dnstwister" do
    before { allow(Mihari::Analyzers::DNSTwister).to receive(:new).and_return(mock) }

    it do
      subject.start ["dnstwister", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#otx" do
    before { allow(Mihari::Analyzers::OTX).to receive(:new).and_return(mock) }

    it do
      subject.start ["otx", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#spyse" do
    before { allow(Mihari::Analyzers::Spyse).to receive(:new).and_return(mock) }

    it do
      subject.start ["spyse", query]
      expect(mock).to have_received(:run).once
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
      expect(subject).to be_required_alert_keys(json)
    end

    context "when given an invalid input" do
      it do
        expect(subject).not_to be_required_alert_keys({})
      end
    end
  end

  describe "#symbolize_hash" do
    subject { described_class.new }

    let(:hash) { { "a" => 1 } }

    it do
      res = subject.symbolize_hash(hash)
      expect(res).to eq(a: 1)
    end
  end

  describe "#normalize_options" do
    subject { described_class.new }

    let(:hash) { { a: 1, config: "foo" } }

    it do
      res = subject.normalize_options(hash)
      expect(res).to eq(a: 1)
    end
  end
end
