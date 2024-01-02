# frozen_string_literal: true

RSpec.describe Mihari::Web::Middleware::CaptureExceptions do
  include_context "with mocked logger"

  describe "#capture_exception" do
    it do
      described_class.new(nil).capture_exception(ZeroDivisionError.new, nil)
      expect(logger_output).to include("ZeroDivisionError")
    end
  end
end
