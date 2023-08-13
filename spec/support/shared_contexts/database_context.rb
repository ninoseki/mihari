# frozen_string_literal: true

RSpec.shared_context "with database fixtures" do
  before do
    # create rules
    rule1 = Mihari::Services::RuleProxy.new(
      id: "test1",
      title: "test1",
      description: "test1",
      queries: [{ analyzer: "crtsh", query: "foo" }],
      tags: ["tag1"]
    )
    rule1.model.save

    rule2 = Mihari::Services::RuleProxy.new(
      id: "test2",
      title: "test2",
      description: "test2",
      queries: [{ analyzer: "crtsh", query: "foo" }],
      tags: ["tag2"]
    )
    rule2.model.save

    # create alerts & aritfaicts
    as = Mihari::AutonomousSystem.new(asn: 13_335)
    reverse_dns_name = Mihari::ReverseDnsName.new(name: "one.one.one.one")
    dns_record = Mihari::DnsRecord.new(resource: "A", value: "93.184.216.34")

    db1 = Mihari::Emitters::Database.new(artifacts: [
      Mihari::Artifact.new(data: "1.1.1.1", autonomous_system: as, reverse_dns_names: [reverse_dns_name])
    ], rule: rule1)
    db1.emit

    db2 = Mihari::Emitters::Database.new(artifacts: [Mihari::Artifact.new(data: "example.com", dns_records: [dns_record])],
      rule: rule2)
    db2.emit
  end
end
