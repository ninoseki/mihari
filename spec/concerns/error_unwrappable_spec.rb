# frozen_string_literal: true

class ErrorTest
  include Mihari::Concerns::ErrorUnwrappable

  def raise_try_error
    Dry::Monads::Try[StandardError] do
      1 / 0
    end.value!
  end

  def raise_result_error
    Dry::Monads::Try[StandardError] do
      1 / 0
    end.to_result.value!
  end

  def raise_error
    1 / 0
  end
end

RSpec.describe Mihari::Concerns::ErrorUnwrappable do
  subject(:test) { ErrorTest.new }

  describe "#unwrap_error" do
    it do
      test.raise_try_error
    rescue => e
      expect(e).not_to be_a ZeroDivisionError
      expect(test.unwrap_error(e)).to be_a ZeroDivisionError
    end

    it do
      test.raise_result_error
    rescue => e
      expect(e).not_to be_a ZeroDivisionError
      expect(test.unwrap_error(e)).to be_a ZeroDivisionError
    end

    it do
      test.raise_error
    rescue => e
      expect(e).to be_a ZeroDivisionError
      expect(test.unwrap_error(e)).to be_a ZeroDivisionError
    end
  end
end
