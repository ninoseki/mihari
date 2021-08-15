# frozen_string_literal: true

RSpec.shared_context "with database fixtures" do
  before do
    artifacts = [
      Mihari::Artifact.new(data: "1.1.1.1"),
      Mihari::Artifact.new(data: "example.com")
    ]

    database = Mihari::Emitters::Database.new
    alert1 = database.emit(title: "test", description: "test", artifacts: artifacts, source: "json", tags: %w[tag1])
    alert2 = database.emit(title: "test2", description: "tes2t", artifacts: artifacts, source: "json", tags: %w[tag2])
    @alerts = [alert1, alert2]
  end

  after do
    Mihari::Alert.all.destroy_all
    Mihari::Artifact.all.destroy_all
    Mihari::Tagging.all.destroy_all
    Mihari::Tag.all.destroy_all
  end
end
