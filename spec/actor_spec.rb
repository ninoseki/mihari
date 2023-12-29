# frozen_string_literal: true

class ActorTest < Mihari::Actor
  def call
    1 / 0
  end
end

RSpec.describe Mihari::Actor do
  subject(:actor) { ActorTest.new }

  describe "#call" do
    it do
      expect { actor.call }.to raise_error(ZeroDivisionError)
    end
  end

  describe "#result" do
    it do
      expect(actor.result.failure).to be_a(ZeroDivisionError)
    end
  end
end
