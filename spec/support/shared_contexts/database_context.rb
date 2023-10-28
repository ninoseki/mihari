# frozen_string_literal: true

RSpec.shared_context "with database fixtures" do
  before_all do
    # create rules
    rule1 = Mihari::Rule.new(
      id: SecureRandom.uuid,
      title: Faker::Name.unique.name,
      description: Faker::Name.unique.name,
      queries: [{ analyzer: "crtsh", query: "foo" }],
      tags: [Faker::Name.unique.name],
      emitters: [{ emitter: "database" }]
    )
    rule1.model.save

    rule2 = Mihari::Rule.new(
      id: SecureRandom.uuid,
      title: Faker::Name.unique.name,
      description: Faker::Name.unique.name,
      queries: [{ analyzer: "crtsh", query: "foo" }],
      tags: [Faker::Name.unique.name],
      emitters: [{ emitter: "database" }]
    )
    rule2.model.save

    # create alerts & artifacts
    as = Mihari::Models::AutonomousSystem.new(asn: Faker::Number.unique.number(digits: 4))
    reverse_dns_name = Mihari::Models::ReverseDnsName.new(name: Faker::Internet.unique.domain_name)
    dns_record = Mihari::Models::DnsRecord.new(resource: "A", value: Faker::Internet.unique.ip_v4_address)

    Mihari::Emitters::Database.new(rule: rule1).emit([Mihari::Models::Artifact.new(
      data: Faker::Internet.unique.ip_v4_address, autonomous_system: as, reverse_dns_names: [reverse_dns_name]
    )])
    Mihari::Emitters::Database.new(rule: rule2).emit([Mihari::Models::Artifact.new(
      data: Faker::Internet.domain_name, dns_records: [dns_record]
    )])
  end
end
