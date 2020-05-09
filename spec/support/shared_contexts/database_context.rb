# frozen_string_literal: true

RSpec.shared_context "with database" do
  after do
    Mihari::Alert.destroy_all
  end
end
