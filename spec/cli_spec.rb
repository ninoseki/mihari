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

  describe "#securitytrailsDomainFeed" do
    before { allow(Mihari::Analyzers::SecurityTrailsDomainFeed).to receive(:new).and_return(mock) }

    it do
      subject.start ["securitytrails_domain_feed", query]
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

  describe "#passive_dns" do
    before { allow(Mihari::Analyzers::PassiveDNS).to receive(:new).and_return(mock) }

    it do
      subject.start ["passive_dns", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#passive_ssl" do
    before { allow(Mihari::Analyzers::PassiveSSL).to receive(:new).and_return(mock) }

    it do
      subject.start ["passive_ssl", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#revese_whois" do
    before { allow(Mihari::Analyzers::ReveseWhois).to receive(:new).and_return(mock) }

    it do
      subject.start ["reverse_whois", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#http_hash" do
    before { allow(Mihari::Analyzers::HTTPHash).to receive(:new).and_return(mock) }

    it do
      subject.start ["http_hash"]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#http_hash" do
    before { allow(Mihari::Analyzers::SSHFingerprint).to receive(:new).and_return(mock) }

    it do
      subject.start ["ssh_fingerprint", query]
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

  describe "#symbolize_hash_keys" do
    subject { described_class.new }

    let(:hash) { { "a" => 1 } }

    it do
      res = subject.symbolize_hash_keys(hash)
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
