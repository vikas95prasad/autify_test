require 'rails_helper'

RSpec.describe Assertions::SnapshotService do
  let(:assertion) { create(:assertion) }
  let(:page_content) { '<html><body><h1>Example Domain</h1></body></html>' }
  let(:service) { described_class.new(assertion, page_content) }

  it 'creates a snapshot directory and saves HTML content' do
    service.call

    snapshot_dir = Rails.root.join('public', 'snapshots', assertion.id.to_s)
    expect(Dir.exist?(snapshot_dir)).to be true
    expect(File.exist?(snapshot_dir.join('index.html'))).to be true
  end
end
