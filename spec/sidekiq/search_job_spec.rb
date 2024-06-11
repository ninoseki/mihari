# frozen_string_literal: true

RSpec.describe Mihari::Jobs::SearchJob do
  include_context "with faked Sidekiq configuration"

  let_it_be(:rule) { FactoryBot.create(:rule) }

  it do
    Sidekiq::Testing.inline! do
      res = described_class.perform_async(rule.id)
      expect(res).not_to be_nil
    end
  end
end
