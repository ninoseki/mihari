# frozen_string_literal: true

RSpec.shared_context "with mocked logger" do
  let(:sio) { StringIO.new }
  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Mihari"]
  end
  let(:logger_output) do
    SemanticLogger.flush
    sio.rewind
    sio.read
  end

  before { allow(Mihari).to receive(:logger).and_return(logger) }

  after { SemanticLogger.flush }
end
