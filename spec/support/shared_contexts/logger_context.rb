# frozen_string_literal: true

RSpec.shared_context "with mocked logger" do
  let(:sio) { StringIO.new }
  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Mihari"]
  end

  before do
    allow(Mihari).to receive(:logger).and_return(logger)
  end

  after do
    SemanticLogger.flush
  end
end
