# frozen_string_literal: true

FactoryBot.define do
  factory :alert, class: "Mihari::Models::Alert" do
    rule

    factory :alert_with_artifacts do
      after(:create) do |alert, _context|
        create(:artifact, :ip, alert:)
        create(:artifact, :domain, alert:)
        create(:artifact, :url, alert:)
        create(:artifact, :mail, alert:)
        create(:artifact, :hash, alert:)
      end
    end
  end
end
