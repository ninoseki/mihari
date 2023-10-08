# frozen_string_literal: true

RSpec.shared_context "with database fixtures" do
  before_all do
    # create rules
    rule1 = Mihari::Services::RuleProxy.new(
      id: SecureRandom.uuid,
      title: Faker::Name.unique.name,
      description: Faker::Name.unique.name,
      queries: [{ analyzer: "crtsh", query: "foo" }],
      tags: [Faker::Name.unique.name],
      emitters: [{ emitter: "database" }]
    )
    rule1.model.save

    rule2 = Mihari::Services::RuleProxy.new(
      id: SecureRandom.uuid,
      title: Faker::Name.unique.name,
      description: Faker::Name.unique.name,
      queries: [{ analyzer: "crtsh", query: "foo" }],
      tags: [Faker::Name.unique.name],
      emitters: [{ emitter: "database" }]
    )
    rule2.model.save

    # create alerts & artifacts
    as = Mihari::AutonomousSystem.new(asn: Faker::Number.unique.number(digits: 4))
    reverse_dns_name = Mihari::ReverseDnsName.new(name: Faker::Internet.unique.domain_name)
    dns_record = Mihari::DnsRecord.new(resource: "A", value: Faker::Internet.unique.ip_v4_address)

    Mihari::Emitters::Database.new(
      artifacts: [
        Mihari::Artifact.new(
          data: Faker::Internet.unique.ip_v4_address,
          autonomous_system: as,
          reverse_dns_names: [reverse_dns_name]
        )
      ],
      rule: rule1
    ).emit

    Mihari::Emitters::Database.new(
      artifacts: [
        Mihari::Artifact.new(
          data: Faker::Internet.domain_name,
          dns_records: [dns_record]
        )
      ],
      rule: rule2
    ).emit
  end
end
