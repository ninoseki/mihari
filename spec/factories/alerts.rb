# frozen_string_literal: true

FactoryBot.define do
  factory :alert, class: "Mihari::Models::Alert" do
    rule

    factory :alert_with_artifacts do
      after(:create) do |alert, _context|
        create(:artifact, :ip, alert: alert)
        create(:artifact, :domain, alert: alert)
        create(:artifact, :url, alert: alert)
        create(:artifact, :mail, alert: alert)
        create(:artifact, :hash, alert: alert)
      end
    end
  end
end
