# frozen_string_literal: true

class Test
  include Dry::Monads[:try, :result]
  include Mihari::Mixins::ErrorUnwrappable

  def raise_try_error
    Try do
      1 / 0
    end.value!
  end

  def raise_result_error
    Try do
      1 / 0
    end.to_result.value!
  end

  def raise_error
    1 / 0
  end
end

RSpec.describe Test do
  subject(:subject) { described_class.new }

  describe "#unwrap_error" do
    it do
      subject.raise_try_error
    rescue StandardError => e
      expect(e).not_to be_a ZeroDivisionError
      expect(subject.unwrap_error(e)).to be_a ZeroDivisionError
    end

    it do
      subject.raise_result_error
    rescue StandardError => e
      expect(e).not_to be_a ZeroDivisionError
      expect(subject.unwrap_error(e)).to be_a ZeroDivisionError
    end

    it do
      subject.raise_error
    rescue StandardError => e
      expect(e).to be_a ZeroDivisionError
      expect(subject.unwrap_error(e)).to be_a ZeroDivisionError
    end
  end
end
