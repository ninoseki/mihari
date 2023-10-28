# frozen_string_literal: true

class RetriableTest
  include Mihari::Mixins::Retriable

  attr_reader :count, :times, :interval

  def initialize
    @count = 0
    @times = 3
    @interval = 0
  end

  def foo
    retry_on_error(times: times, interval: interval) do
      @count += 1
      bar
    end
  end

  def bar
    Net::HTTP.get("example.com", "/index.html")
  end
end

RSpec.describe RetriableTest do
  before do
    allow(Net::HTTP).to receive(:get).and_raise(Net::OpenTimeout)
  end

  describe "#retry_on_error" do
    subject(:subject) { described_class.new }

    it do
      expect { subject.foo }.to raise_error(Net::OpenTimeout)

      expect(subject.count).to eq(subject.times)
    end
  end
end
