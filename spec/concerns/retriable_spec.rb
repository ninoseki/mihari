# frozen_string_literal: true

class RetriableTest
  include Mihari::Concerns::Retriable

  attr_reader :count, :times, :interval

  def initialize
    @count = 0
    @times = 3
    @interval = 0
  end

  def retriable_get(url)
    retry_on_error(times:, interval:) do
      get url
    end
  end

  def get(url)
    @count += 1
    http.get url
  end

  def http
    Mihari::HTTP::Factory.build
  end
end

RSpec.describe Mihari::Concerns::Retriable do
  subject(:subject) { RetriableTest.new }

  include_context "with fake HTTPBin"

  describe "#retry_on_error" do
    context "with 404" do
      it do
        expect { subject.retriable_get("#{server.base_url}/status/404") }.to raise_error(Mihari::StatusError)
        expect(subject.count).to eq(1)
      end
    end

    context "with 401" do
      it do
        expect { subject.retriable_get("#{server.base_url}/status/401") }.to raise_error(Mihari::StatusError)
        expect(subject.count).to eq(1)
      end
    end

    context "with non-404" do
      it do
        expect { subject.retriable_get("#{server.base_url}/status/500") }.to raise_error(Mihari::StatusError)
        expect(subject.count).to eq(subject.times)
      end
    end

    context "with HTTP::TimeoutError" do
      before do
        allow(subject).to receive(:http).and_return(Mihari::HTTP::Factory.build(timeout: -1))
      end

      it do
        expect { subject.retriable_get("#{server.base_url}/get") }.to raise_error(HTTP::TimeoutError)
        expect(subject.count).to eq(subject.times)
      end
    end
  end
end
