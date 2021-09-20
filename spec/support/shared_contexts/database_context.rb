# frozen_string_literal: true

RSpec.shared_context "with database fixtures" do
  before do
    as = Mihari::AutonomousSystem.new(asn: 13_335)
    reverse_dns_name = Mihari::ReverseDnsName.new(name: "one.one.one.one")
    dns_record = Mihari::DnsRecord.new(resource: "A", value: "93.184.216.34")

    artifacts = [
      Mihari::Artifact.new(data: "1.1.1.1", autonomous_system: as, reverse_dns_names: [reverse_dns_name]),
      Mihari::Artifact.new(data: "example.com", dns_records: [dns_record])
    ]

    database = Mihari::Emitters::Database.new
    alert1 = database.emit(title: "test", description: "test", artifacts: artifacts, source: "json", tags: %w[tag1])
    alert2 = database.emit(title: "test2", description: "tes2t", artifacts: artifacts, source: "json", tags: %w[tag2])
    @alerts = [alert1, alert2]
  end

  after do
    reset_db
  end
end
