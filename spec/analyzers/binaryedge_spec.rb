# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::BinaryEdge, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "sagawa.apk" }
  let(:tags) { %w(test) }

  describe "#title" do
    it do
      expect(subject.title).to eq("BinaryEdge lookup")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "when the API raises a timeout error" do
    describe "#artifacts" do
      before do
        mock = double("API")
        allow(mock).to receive_message_chain(:host, :search).and_raise(BinaryEdge::Error.new("Request time limit exceeded. Please refine your query or specify a smaller time range."))
        allow(BinaryEdge::API).to receive(:new).and_return(mock)
      end

      it do
        expect { subject.artifacts }.to raise_error(Mihari::RetryableError)
      end
    end
  end
end
