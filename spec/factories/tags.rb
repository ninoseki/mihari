# frozen_string_literal: true

FactoryBot.define do
  factory :tag, class: "Mihari::Models::Tag" do
    name { Faker::Internet.unique.slug }
  end
end
