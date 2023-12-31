# frozen_string_literal: true

FactoryBot.define do
  factory :rule, class: "Mihari::Models::Rule" do
    id { Faker::Internet.unique.uuid }
    title { Faker::Internet.unique.slug }
    description { Faker::Internet.unique.slug }
    tags { build_list :tag, 1 }
    data do
      {
        id: id,
        title: title,
        description: description,
        queries: [],
        tags: [],
        emitters: []
      }
    end

    factory :rule_with_alerts do
      transient do
        alerts_count { 1 }
      end

      after(:create) do |rule, context|
        create_list(
          :alert_with_artifacts,
          context.alerts_count,
          rule: rule
        )
      end
    end
  end
end
