# frozen_string_literal: true

RSpec.describe Mihari::Notifiers::ExceptionNotifier do
  subject { described_class.new }

  let(:message) { "foo bar" }
  let(:exception) { StandardError.new(message) }

  describe "#to_attachments" do
    it do
      keys = [:color, :text, :fields, :mrkdwn_in].sort
      attachments = subject.to_attachments(exception, message)
      expect(attachments.all? { |attachment| attachment.keys.sort == keys }).to eq(true)
    end
  end

  describe "#to_text" do
    it do
      text = subject.to_text(exception.class)
      expect(text).to eq("*A* `StandardError` *occured in background*\n")
    end
  end

  describe "#to_fields" do
    it do
      keys = [:title, :value].sort
      fields = subject.to_fields(message, exception.backtrace)
      expect(fields.all? { |field| field.keys.sort == keys }).to eq(true)
    end
  end
end
