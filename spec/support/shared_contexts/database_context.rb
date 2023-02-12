# frozen_string_literal: true

RSpec.shared_context "with database fixtures" do
  before do
    # create rules
    data = { id: "test", title: "test", description: "test", queries: [{ analyzer: "crtsh", query: "foo" }] }

    rule1 = Mihari::Rule.new(id: "test1", title: "test1", description: "test1", data: data)
    rule1.save

    rule2 = Mihari::Rule.new(id: "test2", title: "test2", description: "test2", data: data)
    rule2.save

    # create alerts & aritfaicts
    as = Mihari::AutonomousSystem.new(asn: 13_335)
    reverse_dns_name = Mihari::ReverseDnsName.new(name: "one.one.one.one")
    dns_record = Mihari::DnsRecord.new(resource: "A", value: "93.184.216.34")

    database = Mihari::Emitters::Database.new
    database.emit(
      artifacts: [
        Mihari::Artifact.new(data: "1.1.1.1", autonomous_system: as, reverse_dns_names: [reverse_dns_name])
      ],
      rule: rule1,
      tags: %w[tag1]
    )

    database.emit(
      artifacts: [
        Mihari::Artifact.new(data: "example.com", dns_records: [dns_record])
      ],
      rule: rule2,
      tags: %w[tag2]
    )
  end

  after do
    reset_db
  end
end
