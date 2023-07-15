# frozen_string_literal: true

RSpec.describe Mihari do
  it "has a version number" do
    expect(Mihari::VERSION).not_to be nil
  end

  it "has a config" do
    expect(Mihari.config).not_to be nil
  end
end
