RSpec.describe Mihari::Jobs::SearchJob do
  let_it_be(:rule) { FactoryBot.create(:rule) }

  it do
    Sidekiq::Testing.inline! do
      res = described_class.perform_async(rule.id)
      expect(res).not_to be nil
    end
  end
end
