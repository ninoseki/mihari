# frozen_string_literal: true

RSpec.describe Mihari::DataType do
  subject(:data_type) { described_class }

  describe ".type" do
    where(:data, :expected) do
      [
        ["1.1.1.1", "ip"],
        ["3ffe:505:2::1", "ip"],
        ["example.com", "domain"],
        ["http://example.com", "url"],
        ["275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f", "hash"],
        ["example@example.com", "mail"],
        ["1.1.1.1/0", nil],
        ["foo", nil]
      ]
    end

    with_them do
      it do
        expect(data_type.type(data)).to eq(expected)
      end
    end
  end

  describe ".detailed_type" do
    where(:data, :expected) do
      [
        %w[275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f sha256],
        %w[7c552ab044c76d1df4f5ddf358807bfdcd07fa57 sha1],
        %w[44d88612fea8a8f36de82e1278abb02f md5]
      ]
    end

    with_them do
      it do
        expect(data_type.detailed_type(data)).to eq(expected)
      end
    end
  end
end
