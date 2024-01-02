# frozen_string_literal: true

FactoryBot.define do
  factory :autonomous_system, class: "Mihari::Models::AutonomousSystem" do
    artifact

    asn { Faker::Number.unique.number(digits: 4) }
  end

  factory :reverse_dns_name, class: "Mihari::Models::ReverseDnsName" do
    artifact
    name { Faker::Internet.unique.domain_name }
  end

  factory :dns_record, class: "Mihari::Models::DnsRecord" do
    artifact

    resource { "A" }
    value { Faker::Internet.unique.ip_v4_address }
  end

  factory :artifact, class: "Mihari::Models::Artifact" do
    alert

    data { Faker::Internet.unique.ip_v4_address }
    data_type { Mihari::DataType.type(data) }

    trait :ip do
      data { Faker::Internet.unique.ip_v4_address }
    end

    trait :domain do
      data { Faker::Internet.unique.domain_name }
    end

    trait :url do
      data { Faker::Internet.unique.url }
    end

    trait :mail do
      data { Faker::Internet.unique.email }
    end

    trait :hash do
      data { Faker::Crypto.unique.md5 }
    end

    after(:create) do |artifact|
      case artifact.data_type
      when "ip"
        create(:autonomous_system, artifact: artifact)
        create_list(:reverse_dns_name, 1, artifact: artifact)
      when "domain"
        create_list(:dns_record, 1, artifact: artifact)
      when "url"
        create_list(:dns_record, 1, artifact: artifact)
      end
    end
  end
end
