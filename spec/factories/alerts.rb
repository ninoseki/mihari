FactoryBot.define do
  factory :alert, class: "Mihari::Models::Alert" do
    rule

    factory :alert_with_artifacts do
      after(:create) do |alert, _context|
        # create ip and domain type artifacts
        # TODO: create url, hash and mail type artifacts
        create(:artifact, :ip, alert: alert)
        create(:artifact, :domain, alert: alert)
      end
    end
  end
end
