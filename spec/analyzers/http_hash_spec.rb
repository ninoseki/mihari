# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::HTTPHash do
  subject { described_class.new(nil, md5: md5, sha256: sha256, mmh3: mmh3, tags: tags) }

  let(:tags) { %w(test) }

  let(:md5) { "44d88612fea8a8f36de82e1278abb02f" }
  let(:sha256) { "275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f" }
  let(:mmh3) { 111 }
  let(:mock) { instance_double("Analyzer") }

  before do
    allow(mock).to receive(:artifacts).and_return([])

    allow(Mihari::Analyzers::BinaryEdge).to receive(:new).with(sha256).and_return(mock)
    allow(Mihari::Analyzers::Censys).to receive(:new).with(sha256).and_return(mock)
    allow(Mihari::Analyzers::Onyphe).to receive(:new).with("app.http.bodymd5:#{md5}").and_return(mock)
    allow(Mihari::Analyzers::Shodan).to receive(:new).with("http.html_hash:#{mmh3}").and_return(mock)
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("HTTP hash cross search")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = md5:44d88612fea8a8f36de82e1278abb02f,sha256:275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f,mmh3:111")
    end
  end

  describe "#artifacts" do
    before do
      allow(Parallel).to receive(:processor_count).and_return(0)
    end

    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "when given --html option" do
    subject { described_class.new(nil, html: html) }

    let(:html) { File.expand_path("../fixtures/test.html", __dir__) }

    describe "#description" do
      it do
        expect(subject.description).to eq("query = md5:86dc3ed0a52d7368996b098efcc6fdfe,sha256:243d33d1c08d00f373ae490a99f58d4a3b1251a017d7e3baea95f412391615d0,mmh3:-576284617")
      end
    end
  end
end
